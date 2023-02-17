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
        let router = ProfileViewRouter(viewController: viewController)
        let presenter = ProfileViewPresenter(router: router, viewController: viewController)
        viewController.presenter = presenter
        return viewController
    }
}
