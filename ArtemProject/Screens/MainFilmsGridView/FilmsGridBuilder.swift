//
//  FilmsGridBuilder.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 27.01.2023.
//

import UIKit

final class FilmsGridBuilder {    
    static func build() -> FilmsGridViewController {
        let networkClient = NetworkService()
        let viewController = FilmsGridViewController()
        let router = FilmsGridRouter(viewController: viewController)
        let presenter = FilmsGridPresenter(router: router, controller: viewController, networkClient: networkClient)
        viewController.presenter = presenter
        return viewController
    }
}
