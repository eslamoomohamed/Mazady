//
//  SectionHeaderView.swift
//  Mazady
//
//  Created by eslam mohamed on 30/04/2025.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {

    @IBOutlet private weak var headerName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    func configure(with headerTitle: String) {
        self.headerName.text = headerTitle
    }
}

// MARK: Helper methods
private extension SectionHeaderView {
    func configureViews() {
        configureHeaderLabel()
    }

    func configureHeaderLabel() {
        headerName.applyStyle(textColor: .charcoalGray, font: UIFont(name: Fonts.nunitoRegular, size: 16))
    }
}
