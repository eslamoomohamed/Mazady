//
//  AdvertisementsResponse.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

struct AdvertisementsResponse: Codable {
    let advertisements: [Advertisement]
}

struct Advertisement: Codable {
    let id: Int
    let image: String
}
