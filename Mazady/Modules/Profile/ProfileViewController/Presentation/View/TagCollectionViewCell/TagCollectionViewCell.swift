//
//  TagCollectionViewCell.swift
//  Mazady
//
//  Created by eslam mohamed on 30/04/2025.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        configureViews()
    }

    override var isSelected: Bool {
        didSet {
            updateSelectionAppearance()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.addCornerRaduis(6)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        tagLabel.text = nil
        tagLabel.applyStyle(textColor: .charcoalGrayColor, font: UIFont(name: Fonts.nunitoRegular, size: 14))
    }

    func configure(with viewModel: TagCollectionViewCellModel) {
        tagLabel.text = viewModel.tagName
    }
}

// MARK: Helper methods
private extension TagCollectionViewCell {
    func configureViews() {
        configureContainerView()
        configureTagLabel()
    }

    func configureContainerView() {
        containerView.addBorder()
        containerView.backgroundColor = .systemBackground
    }

    func configureTagLabel() {
        tagLabel.applyStyle(textColor: .charcoalGrayColor, font: UIFont(name: Fonts.nunitoRegular, size: 14))
    }

    func updateSelectionAppearance() {
        if isSelected {
            containerView.backgroundColor = .secondaryOrangeColor.withAlphaComponent(0.20)
            containerView.layer.borderColor = UIColor.secondaryOrangeColor.cgColor
            tagLabel.applyStyle(textColor: .secondaryOrangeColor, font: UIFont(name: Fonts.nunitoRegular, size: 14))
        } else {
            containerView.backgroundColor = .systemBackground
            containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.20).cgColor
            tagLabel.applyStyle(textColor: .charcoalGrayColor, font: UIFont(name: Fonts.nunitoRegular, size: 14))
        }
    }
}
