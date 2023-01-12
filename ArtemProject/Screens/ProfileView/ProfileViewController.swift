//
//  ProfileViewController.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 07.01.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        print("branch test")
        //
        print("branch test 2")
    }
    
    func setup() {
        view.backgroundColor = .red
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        label.text = "Profile"
        label.textAlignment = .center
    }
}
