//
//  ProfileViewBuilder.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 07.02.2023.
//

import UIKit

final class ProfileViewBuilder {
    static func build() -> UIViewController {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenter(viewController: viewController, title: "Profile")
        viewController.presenter = presenter
        return viewController
    }
}
