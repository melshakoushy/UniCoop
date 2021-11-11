//
//  NetworkManager.swift
//  UnionCoop
//
//  Created by Mahmoud Elshakoushy on 08/11/2021.
//

import Alamofire
import Foundation
import Reachability
import RxSwift
import SwiftMessages

class NetworkManager: RequestInterceptor {
    
    
    static let shared = NetworkManager()
    private var retryLimit = 2
    var disposeBag = DisposeBag()
    private init() {}
    fileprivate var reachability: Reachability?
    
    func isInternetAvailable() -> Bool {
        return (NetworkReachabilityManager()?.isReachable)!
    }
}

// MARK: - process api reqest

extension NetworkManager {
    func processReq<T>(url: String, method: HTTPMethod, returnType: T.Type, headers: Dictionary<String, String>? = nil, params: Alamofire.Parameters? = nil, interceptor: RequestInterceptor? = nil ,encoding: ParameterEncoding = JSONEncoding.default) -> Observable<T?> where T: Codable {
        let objResponse = PublishSubject<T?>()
        if NetworkManager.shared.isInternetAvailable() {
            let date = Date()

            AF.request(url, method: method, parameters: params, encoding: encoding, headers: HTTPHeaders(headers ?? [:]), interceptor: self, requestModifier: { $0.timeoutInterval = 60 }).validate().responseJSON { [weak self] response in
                //print("Response",response)
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    self?.parseResponse(data: response.data, objResponse: objResponse)
                    if let JSON = response.value as? [String: Any] {
                        if let error = JSON["error"] as? [String: Any] {
                            if let data = error["data"] as? [String: Any] {
                                let message = data["message"] as! String
                                print(message as Any)
                                let error = MessageView.viewFromNib(layout: .messageView)
                                error.configureTheme(.error)
                                error.configureContent(title: "Error", body: message)
                                error.button?.isHidden = true
                                SwiftMessages.show(view: error)

                            }
                        }
                    }
                case let .failure(error):
                    if error._code == NSURLErrorTimedOut {
                        self?.handleError(error: .noInternet, data: response.data, objResponse: objResponse)
                    }
                    if response.response?.statusCode == 422 {
                        self?.handleError(error: .validationError, data: response.data, objResponse: objResponse)
                    } else if response.response?.statusCode == 401 { // unauthenticated
                        self?.handleError(error: .unauthenticated, data: response.data, objResponse: objResponse)
                    }   else if response.response?.statusCode == 400{
                            self?.handleError(error: .suspended, data: response.data, objResponse: objResponse)
                        
                    } else {
                        self?.handleError(error: .serverError, data: response.data, objResponse: objResponse)
                    }
                }
            }
        } else {
            handleError(error: .noInternet, data: nil, objResponse: objResponse)
        }
        return objResponse
    }
}

// MARK: -parse response JSON

extension NetworkManager {
    fileprivate func parseResponse<T>(data: Data?, returnType: T.Type) -> T? where T: Codable {
        var response: T? = nil
        if let _ = data {
            do {
                response = try JSONDecoder().decode(T.self, from: data!)
            } catch {
                response = nil
                showError(error: .serverError)
            }
        }
        return response
    }

    fileprivate func parseResponse<T>(data: Data?, objResponse: PublishSubject<T?>) where T: Codable {
        if let _ = data {
            do {
                let response = try JSONDecoder().decode(T.self, from: data!)
                objResponse.onNext(response)
                objResponse.onCompleted()
            } catch {
                print(error)
                handleError(error: .couldNotParseJson, data: data, objResponse: objResponse, checkMessage: true)
            }
        }
    }
}


// MARK: - handle Error

extension NetworkManager {
    func handleError<T>(error: NetworkErrorType, data: Data?, objResponse: PublishSubject<T?>, checkMessage: Bool = false) {
//        objResponse.onNext(nil)
        let errorReponse = parseResponse(data: data, returnType: ActionModel<ApiGenericModel>.self)
        objResponse.onError(NetWorkError(errorType: error, error: errorReponse))
        objResponse.onCompleted()
        showError(error: error)
    }

    func showError(error: NetworkErrorType) {
    }
}

extension NetworkManager {
    func setupInternetConnectionListener() {
        if reachability != nil {
            reachability?.stopNotifier()
            reachability = nil
        }
        reachability = try! Reachability()
        reachability?.whenReachable = { _ in
            // TODO: To be used to check with firebase
        }
        reachability?.whenUnreachable = { _ in
            print("Not reachable")
        }
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}

extension Dictionary {
    var json: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? "Not a valid JSON"
        } catch {
            return "Not a valid JSON"
        }
    }
}
