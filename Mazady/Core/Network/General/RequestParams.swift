//
//  RequestParams.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

enum RequestParams {
    case body(_: [String: Any]?)
    case url(_: [String: Any]?)

    func toString() -> String {
        switch self {
        case .body(let parameters), .url(let parameters):
            if let parameters = parameters {
                do {
                    let data = try JSONSerialization.data(withJSONObject: parameters, options: [.sortedKeys])
                    if let string = String(data: data, encoding: .utf8) {
                        return string
                    }
                } catch {
                    print(error)
                }
            }
        }
        return ""
    }
}

