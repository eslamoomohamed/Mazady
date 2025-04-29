//
//  AllTagsResponse .swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

struct AllTagsResponse: Codable {
    let tags: [Tag]
}

struct Tag: Codable {
    let id: Int
    let name: String
}
