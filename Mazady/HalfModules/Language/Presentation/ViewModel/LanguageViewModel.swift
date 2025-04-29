//
//  LanguageViewModel.swift
//  Mazady
//
//  Created by eslam mohamed on 30/04/2025.
//

import Foundation

class LanguageViewModel {
    
    let changeLanguageTitle: String = "profile_scene.language.change_language_text".localized
    let languages: [String] = ["English", "عربي"]
    private let localizationManager = LocalizationManager.shared
    
    func isLanguageSelected(_ language: String) -> Bool {
        guard let currentLanguage = localizationManager.getLanguage() else {
            return false
        }
        
        switch language {
        case "English":
            return currentLanguage == .English
        case "عربي":
            return currentLanguage == .Arabic
        default:
            return false
        }
    }
    
    func selectLanguage(_ language: String) {
        switch language {
        case "English":
            localizationManager.setLanguage(language: .English)
        case "عربي":
            localizationManager.setLanguage(language: .Arabic)
        default:
            break
        }
    }
    
    func numberOfLanguages() -> Int {
        return languages.count
    }
    
    func language(at index: Int) -> String {
        return languages[index]
    }
    
    func shouldHideSeparator(for index: Int) -> Bool {
        return index == languages.count - 1
    }
}
