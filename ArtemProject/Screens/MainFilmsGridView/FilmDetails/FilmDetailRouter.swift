//
//  FilmDetailRouter.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 02.02.2023.
//

import UIKit

protocol FilmDetailRouterProtocol {
    func popOutView()
}

class FilmDetailRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension FilmDetailRouter: FilmDetailRouterProtocol {
    func popOutView() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
}
