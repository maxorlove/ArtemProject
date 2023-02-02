//
//  FilmDetailBuilder.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 27.01.2023.
//

import UIKit

final class FilmDetailBuilder {
    static func build(data: DetailDataStruct) -> UIViewController {
        let controller = FilmDetailController()
        let router = FilmDetailRouter(viewController: controller)
        let presenter = FilmDetailPresenter(
            networkClient: NetworkService(),
            controller: controller,
            router: router,
            data: data)
        controller.presenter = presenter
        return controller
    }
}
