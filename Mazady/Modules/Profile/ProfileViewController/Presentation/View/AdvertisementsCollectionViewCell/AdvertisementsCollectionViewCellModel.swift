//
//  AdvertisementsCollectionViewCellModel.swift
//  Mazady
//
//  Created by eslam mohamed on 30/04/2025.
//

import Foundation

class AdvertisementsCollectionViewCellModel {
    
    private let advertisement: Advertisement
    let uuid: UUID

    init(advertisement: Advertisement) {
        self.advertisement = advertisement
        self.uuid = UUID()
    }

    var imageURL: String {
        advertisement.image
    }
    
}
