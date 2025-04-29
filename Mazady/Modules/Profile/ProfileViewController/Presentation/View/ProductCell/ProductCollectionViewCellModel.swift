//
//  ProductCollectionViewCellModel.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

class ProductCollectionViewCellModel {

    let product: Product
    let uuid: UUID

    init(product: Product) {
        self.product = product
        self.uuid = UUID()
    }
}
