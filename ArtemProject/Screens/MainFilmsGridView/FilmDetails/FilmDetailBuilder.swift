//
//  FilmDetailBuilder.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 27.01.2023.
//

import UIKit

final class FilmDetailBuilder {
    static func build(data: DetailDataStruct) -> UIViewController {
        let viewController = FilmDetailController()
        let router = FilmDetailRouter(viewController: viewController)
        let presenter = FilmDetailPresenter(
            networkClient: NetworkService(),
            controller: viewController,
            router: router,
            data: data)
        viewController.presenter = presenter
        return viewController
    }
}
