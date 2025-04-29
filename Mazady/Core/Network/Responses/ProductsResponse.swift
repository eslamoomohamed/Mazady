//
//  ProductsResponse.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

struct ProductsResponse: Codable {
    let products: [Product]
}

struct Product: Codable, Hashable {
    let id: Int
    let name: String
    let image: String
    let price: Double
    let currency: String
    let offer: Double?
    let endDate: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case price
        case currency
        case offer
        case endDate = "end_date"
    }
}
