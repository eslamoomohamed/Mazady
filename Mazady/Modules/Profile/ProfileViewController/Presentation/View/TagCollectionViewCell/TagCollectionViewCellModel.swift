//
//  TagCollectionViewCellModel.swift
//  Mazady
//
//  Created by eslam mohamed on 30/04/2025.
//

import Foundation

class TagCollectionViewCellModel {
    private let tag: Tag
    var isSelected: Bool = false

    init(tag: Tag) {
        self.tag = tag
    }

    var tagName: String {
        tag.name
    }
}
