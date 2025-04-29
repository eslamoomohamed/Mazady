//
//  LocalizationManager.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//


import Foundation
import UIKit

    protocol LocalizationDelegate: AnyObject {
        func setRootWithTransition()
    }

    class LocalizationManager: NSObject {
        
        static let shared = LocalizationManager()
        private var bundle: Bundle = Bundle.main
        weak var delegate: LocalizationDelegate?
        var isRTL: Bool {
            return getLanguage() == .Arabic
        }
        
        //MARK: - Get currently selected language from user defaults
        func getLanguage() -> Language? {
            if let languageCode = UserDefaults.standard.value(forKey: "PrefLang") as? String,
                let language = Language(rawValue: languageCode) {
                return language
            }
            return nil
        }
        
        //MARK: - Configure startup language
        func setAppInitLanguage() {
            if let selectedLanguage = getLanguage() {
                setLanguage(language: selectedLanguage)
            } else {
                if let languageCode = Locale.preferredLanguages.first,
                    languageCode.contains("ar") {
                    setLanguage(language: .Arabic)
                }else {
                    setLanguage(language: .English)
                }
            }
        }
        
        //MARK: - Set language for localization
        func setLanguage(language: Language) {
            UserDefaults.standard.set(language.rawValue, forKey: "PrefLang")
            if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj") {
                bundle = Bundle(path: path) ?? Bundle.main
            }
            UserDefaults.standard.synchronize()
            setAppDirection()
        }
        
        //MARK: - Reset app for the new language
        func setAppDirection() {
            let direction = getLanguageDirection()
            var semantic: UISemanticContentAttribute!
            switch direction {
            case .LTR:
                semantic = .forceLeftToRight
            case .RTL:
                semantic = .forceRightToLeft
            }
            UINavigationBar.appearance().semanticContentAttribute = semantic
            UIView.appearance().semanticContentAttribute = semantic
            UILabel.appearance().semanticContentAttribute = semantic
            UITextField.appearance().semanticContentAttribute = semantic
            UITextView.appearance().semanticContentAttribute = semantic
            UIButton.appearance().semanticContentAttribute = semantic
            UIStackView.appearance().semanticContentAttribute = semantic
            UISwitch.appearance().semanticContentAttribute = semantic
            UITableView.appearance().semanticContentAttribute = semantic
            UITableViewCell.appearance().semanticContentAttribute = semantic
            UITabBar.appearance().semanticContentAttribute = semantic
            UISearchBar.appearance().semanticContentAttribute = semantic
            UIImageView.appearance().semanticContentAttribute = semantic
            delegate?.setRootWithTransition()
        }
        
        //MARK: - Check the language direction
        private func getLanguageDirection() -> LanguageDirection {
            if let lang = getLanguage() {
                switch lang {
                case .English:
                    return .LTR
                case .Arabic:
                    return .RTL
                }
            }
            return .LTR
        }

        //MARK: - Get localized string for a given code from the active bundle
        func localizedString(for key: String, value comment: String) -> String {
            let localized = bundle.localizedString(forKey: key, value: comment, table: nil)
            return localized
        }
    }

    extension LocalizationManager {
        enum LanguageDirection {
            case LTR
            case RTL
        }
        
        enum Language: String {
            case English = "en"
            case Arabic = "ar"
        }
    }

extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self, value: "")
    }
}
