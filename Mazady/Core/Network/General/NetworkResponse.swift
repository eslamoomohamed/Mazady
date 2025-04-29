//
//  NetworkResponse.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

enum NetworkResponse {
    case data(_: Int?, _: Data)
    case error(_: Int?, _: NSError?)

    init(_ response: (httpUrlResponse: HTTPURLResponse?, data: Data?, error: Error?), for request: NetworkRequest) {
        let successCodes = 200...499

        guard let statusCode = response.httpUrlResponse?.statusCode,
              successCodes.contains(statusCode),
              response.error == nil else {
            self = .error(response.httpUrlResponse?.statusCode, response.error as NSError?)
            return
        }

        guard let data = response.data else {
            self = .error(response.httpUrlResponse?.statusCode, HTTPNetworkError.noData as NSError)
            return
        }

        self = .data(statusCode, data)
    }
}

