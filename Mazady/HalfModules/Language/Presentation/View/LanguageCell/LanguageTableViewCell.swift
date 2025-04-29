//
//  LanguageTableViewCell.swift
//  Mazady
//
//  Created by eslam mohamed on 30/04/2025.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet private weak var isCheckedView: UIView!
    @IBOutlet private weak var isCheckedInnerView: UIView!
    @IBOutlet private weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
        selectionStyle = .none
        backgroundColor = .backgroundColor
    }

    func configure(with language: String, isSelected: Bool) {
        languageLabel.text = language
        isCheckedInnerView.backgroundColor = isSelected ? .secondaryOrangeColor : .white
    }
}


// MARK: - Private helper methods
private extension LanguageTableViewCell {
    func configureViews() {
        isCheckedView.layer.cornerRadius = 10
        isCheckedView.layer.borderWidth = 1.0
        isCheckedView.layer.borderColor = UIColor.secondaryOrangeColor.cgColor
        isCheckedView.backgroundColor = .white
        isCheckedInnerView.layer.cornerRadius = 7
        languageLabel.applyStyle(textColor: .charcoalGray, font: UIFont(name: Fonts.nunitoRegular, size: 16))
    }
}
