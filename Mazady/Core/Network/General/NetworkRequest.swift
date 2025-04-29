//
//  NetworkRequest.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

protocol NetworkRequest {

    var path: String { get }

    var method: HTTPNetworkMethod { get }

    var parameters: RequestParams { get }

    var headers: [HTTPHeaderName: String]? { get }
}

extension NetworkRequest {
    var method: HTTPNetworkMethod {
        return .get
    }

    var parameters: RequestParams {
        return .url(nil)
    }

    var headers: [HTTPHeaderName: String]? {
        return nil
    }
}
