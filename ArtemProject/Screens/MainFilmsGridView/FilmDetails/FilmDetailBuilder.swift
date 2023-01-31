//
//  FilmDetailBuilder.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 27.01.2023.
//

import Foundation

final class FilmDetailBuilder {
    static func build() -> FilmDetailController {
        let controller = FilmDetailController()
        let presenter = FilmDetailPresenter(networkClient: NetworkService(), controller: controller)
        controller.presenter = presenter
        return controller
    }
}
