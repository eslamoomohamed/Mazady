//
//  NetworkManagerProtocol.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

protocol NetworkManagerProtocol {
    var logResponse: Bool { set get }
    func executeRequest<T: Decodable>(_ request: NetworkRequest, completion: @escaping (Result<T, HTTPNetworkError>) -> Void)
}
