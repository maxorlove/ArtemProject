//
//  TabBarController.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 10.01.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        let profileViewController = ProfileViewBuilder.build()
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.tabBarItem.image = UIImage(named: "profileIco")
        profileNavigationController.tabBarItem.title = nil
        profileNavigationController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -15, right: 0)
        
        let filmsGridViewController = FilmsGridBuilder.build()
        let filmsGridNavigationController = UINavigationController(rootViewController: filmsGridViewController)
        filmsGridNavigationController.tabBarItem.image = UIImage(named: "FilmsIco")
        filmsGridNavigationController.title = nil
        filmsGridNavigationController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -15, right: 0)

        self.viewControllers = [filmsGridNavigationController, profileNavigationController]
    }
    
}
