//
//  NetworkManagerProtocol.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

protocol NetworkManagerProtocol {
    var logResponse: Bool { get set }

    func executeRequest<T: Decodable>(_ request: NetworkRequest) async throws -> T
}
