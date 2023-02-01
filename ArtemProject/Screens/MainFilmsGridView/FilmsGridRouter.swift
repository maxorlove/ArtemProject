//
//  FilmsGridRouter.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 01.02.2023.
//

import UIKit

protocol FilmsGridRouterProtocol: AnyObject {
    func showFilmsDetailView(item: Item)
}

final class FilmsGridRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension FilmsGridRouter: FilmsGridRouterProtocol {
    func showFilmsDetailView(item: Item) {
        let filmDetailController = FilmDetailBuilder.build()
        filmDetailController.presenter?.getData(item: item)
        viewController?.navigationController?.pushViewController(filmDetailController, animated: true)
    }
}
