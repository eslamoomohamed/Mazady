//
//  NetworkLoggerType.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

protocol NetworkLoggerType {
    func log(response urlResponse: URLResponse?, data: Data?, error: Error?)
    func log(request urlRequest: URLRequest)
}
