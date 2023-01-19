//
//  TabBarController.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 10.01.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let pv = ProfileViewController()
        pv.setViewTitle(title: "Profile")
        pv.setEditFlag(edit: false)
        let profileViewController = UINavigationController(rootViewController: pv)
        profileViewController.tabBarItem.title = "Profile"
        profileViewController.tabBarItem.image = UIImage(named: "star")
        
        let fv = FilmsGridViewController()
        fv.setViewTitle(title: "Movies")
        let filmsGridViewController = UINavigationController(rootViewController: fv)
        filmsGridViewController.tabBarItem.title = "Films list"
        filmsGridViewController.tabBarItem.image = UIImage(named: "star")
        self.viewControllers = [filmsGridViewController, profileViewController]
    }
    
}
