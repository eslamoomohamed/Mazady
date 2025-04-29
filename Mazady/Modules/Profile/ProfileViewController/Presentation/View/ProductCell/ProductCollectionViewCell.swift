//
//  ProductCollectionViewCell.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var productCategory: UILabel!
    @IBOutlet private weak var priceTitle: UILabel!
    @IBOutlet private weak var priceValue: UILabel!
    @IBOutlet private weak var offerPriceStackView: UIStackView!
    @IBOutlet private weak var offerPriceTitle: UILabel!
    @IBOutlet private weak var offerPriceValue: UILabel!
    @IBOutlet private weak var originalPrice: UILabel!
    @IBOutlet private weak var lotLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addCornerRaduis(20)
        containerView.backgroundColor = .backgroundColor
        containerView.addBorder(1, .gray)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        productImage.addCornerRaduis(12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        productCategory.text = nil
        priceValue.text = nil
        offerPriceStackView.isHidden = true
    }
    
    func configure(with viewModel: ProductCollectionViewCellModel) {
        productImage.downloadImage(from: viewModel.product.image, uuid: viewModel.uuid)
        productCategory.text = viewModel.product.name
        priceTitle.text = "profile_scene.product.price_text".localized
        priceValue.text = "\(viewModel.product.price) \(viewModel.product.currency)"
        
        if let offerPrice = viewModel.product.offer {
            offerPriceStackView.isHidden = false
            offerPriceValue.text = "\(offerPrice) \(viewModel.product.currency)"
            originalPrice.attributedText = "\(viewModel.product.price) \(viewModel.product.currency)".strikethrough()
        } else {
            offerPriceStackView.isHidden = true
        }
    }
}
