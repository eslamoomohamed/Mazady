//
//  Utilities.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import UIKit

protocol TabBarItemRepresentable {
    var title: String { get }
    var systemImageName: String { get }
    var viewController: UIViewController { get }
}

enum MainTab: CaseIterable, TabBarItemRepresentable {
    
    case home
    case search
    case icon
    case cart
    case profile

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .icon:
            return "Icon"
        case .cart:
            return "Cart"
        case .profile:
            return "Profile"
        }
    }

    var systemImageName: String {
        switch self {
        case .home:
            return "house"
        case .search:
            return "magnifyingglass"
        case .icon:
            return "star"
        case .cart:
            return "cart"
        case .profile:
            return "person"
        }
    }

    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController()
        case .search:
            return SearchViewController()
        case .icon:
            return ShopViewController()
        case .cart:
            return CartViewController()
        case .profile:
            let profileVC = ProfileViewController()
            let viewModel = ProfileViewModel()
            profileVC.viewModel = viewModel
            return profileVC
        }
    }
}
