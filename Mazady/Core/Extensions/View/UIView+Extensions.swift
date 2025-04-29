//
//  UIView+Extensions.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import UIKit

extension UIView {
    func addCornerRaduis(_ raduis: CGFloat, _ edges: MaskedCorners = .all) {
        self.layer.cornerRadius = raduis
        switch edges {
        case .all:
            break
        case .top:
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        case .bottom:
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case .left:
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        case .right:
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
    }

    func addBorder(_ width: CGFloat = 1, _ color: UIColor = UIColor.black.withAlphaComponent(0.20)) {
        clipsToBounds = true
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    enum MaskedCorners {
        case all
        case top
        case bottom
        case left
        case right
    }

    enum SafeAreaEdge {
        case top
        case bottom
    }
}
