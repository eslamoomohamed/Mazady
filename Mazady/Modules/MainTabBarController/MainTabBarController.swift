//
//  MainTabBarController.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        viewControllers = MainTab.allCases.map { tab in
            let navController = UINavigationController(rootViewController: tab.viewController)
            navController.tabBarItem = UITabBarItem(title: tab.title, image: UIImage(systemName: tab.systemImageName), tag: 0)
            return navController
        }
    }
}
