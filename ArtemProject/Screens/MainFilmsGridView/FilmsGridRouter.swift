//
//  FilmsGridRouter.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 01.02.2023.
//

import UIKit

protocol FilmsGridRouterProtocol: AnyObject {
    func showFilmsDetailView(data: DetailDataStruct)
}

final class FilmsGridRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension FilmsGridRouter: FilmsGridRouterProtocol {
    func showFilmsDetailView(data: DetailDataStruct) {
        let filmDetailController = FilmDetailBuilder.build(data: data)
        viewController?.navigationController?.pushViewController(filmDetailController, animated: true)
    }
}
