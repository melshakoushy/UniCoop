//
//  NetworkError.swift
//  UnionCoop
//
//  Created by Mahmoud Elshakoushy on 08/11/2021.
//

import Foundation

enum NetworkErrorType {
    case noInternet
    case uploadImageError
    case uploadError
    case couldNotParseJson
    case serverError
    case validationError
    case unauthenticated
    case suspended
}

struct NetWorkError: Error {
    var errorType: NetworkErrorType?
    var error: ApiGenericModel?
}

// MARK: - APIErrorModel

class ApiGenericModel: Codable {
}
