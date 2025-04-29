//
//  HTTPNetworkError.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

enum HTTPNetworkError: Error {
    case parametersNil
    case headersNil
    case encodingFailed
    case decodingFailed
    case missingURL
    case couldNotParse
    case noData
    case unwrappingError
    case dataTaskFailed
    case authenticationError
    case pageNotFound
    case failed
    case serverSideError
    case unableToDecode
    case noInternetConnection
    case other(String)
    case invalidURL
    case networkError(Error?)
    case decodingError(Error)
    case invalidResponse
    case error(statusCode: Int, message: String)
}

struct ErrorResponse: Codable {
    let status: Int
    let result: String
    let message: String
}
