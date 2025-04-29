//
//  UILabel.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import UIKit

extension UILabel {
    func applyStyle(textColor: UIColor?, font: UIFont? = nil, cornerRadius: CGFloat = 0, clipsToBounds: Bool = true) {
        self.textColor = textColor
        self.font = font ?? self.font
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = clipsToBounds
    }
}
