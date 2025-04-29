//
//  String+Extensions.swift
//  Mazady
//
//  Created by eslam mohamed on 01/05/2025.
//

import UIKit

extension String {
    func strikethrough() -> NSAttributedString {
        NSAttributedString(
            string: self,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
    }
}
