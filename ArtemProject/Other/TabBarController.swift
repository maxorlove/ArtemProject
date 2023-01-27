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
        let pv = ProfileViewController()
        pv.setViewTitle(title: "Profile")
        pv.setEditFlag(edit: false)
        let profileViewController = UINavigationController(rootViewController: pv)
        profileViewController.tabBarItem.image = UIImage(named: "profileIco")
        profileViewController.title = nil
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        
        let filmsGridViewController = FilmsGridBuilder.build()
        filmsGridViewController.setViewTitle(title: "Movies")
        let ilmsGridnavigationController = UINavigationController(rootViewController: filmsGridViewController)
        ilmsGridnavigationController.tabBarItem.image = UIImage(named: "filmsIco")
        ilmsGridnavigationController.title = nil
        ilmsGridnavigationController.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        
        self.viewControllers = [ilmsGridnavigationController, profileViewController]
    }
    
}
