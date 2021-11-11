//
//  ServiceType.swift
//  UnionCoop
//
//  Created by Mahmoud Elshakoushy on 08/11/2021.
//

import Foundation

class ServiceType {
    var networkManager = NetworkManager.shared
    
    func getUrl (baseUrl: String, parameters: [String: String]? = nil) -> String {
        var components = URLComponents()
        components.path = baseUrl
        components.queryItems = []
        if let params = parameters {
            for key in params.keys {
                components.queryItems?.append(URLQueryItem(name: key, value: params[key]!))
            }
            return components.url?.absoluteString.removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters: (.urlQueryAllowed)) ?? baseUrl
        }
        return baseUrl
    }
}
