//
//  ProfileViewRouter.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 07.02.2023.
//

import UIKit

protocol ProfileViewRouterProtocol {
    func presentAllert(allert: UIAlertController)
}

class ProfileViewRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension ProfileViewRouter: ProfileViewRouterProtocol {
    func presentAllert(allert: UIAlertController) {
        viewController?.present(allert, animated: true)
    }
}
