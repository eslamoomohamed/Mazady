//
//  AdvertisementsCollectionViewCell.swift
//  Mazady
//
//  Created by eslam mohamed on 30/04/2025.
//

import UIKit

class AdvertisementsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var advertisementImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        advertisementImage.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        advertisementImage.addCornerRaduis(12)
    }

    func configure(with viewModel: AdvertisementsCollectionViewCellModel) {
        advertisementImage.downloadImage(from: viewModel.imageURL, uuid: viewModel.uuid)
    }

}
