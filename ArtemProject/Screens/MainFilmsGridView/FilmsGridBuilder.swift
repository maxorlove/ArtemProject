//
//  FilmsGridBuilder.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 27.01.2023.
//

import UIKit

class FilmsGridBuilder {
    
    static func build() -> FilmsGridViewController {
        let networkClient = NetworkService()
        let viewController = FilmsGridViewController()
        let presenter = FilmsGridPresenter(controller: viewController, networkClient: NetworkService())
        viewController.presenter = presenter
        return viewController
    }
}
