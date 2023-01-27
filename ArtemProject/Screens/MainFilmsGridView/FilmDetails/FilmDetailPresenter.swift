//
//  FilmDetailPresenter.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 27.01.2023.
//

import Foundation

protocol FilmDetailPresenterProtocol: AnyObject {
//    func configure()
    func getData(item: Item)
}

class FilmDetailPresenter {
    weak var controller: FilmDetailControllerProtocol?
    private let networkClient: FilmDetailNetworkProtocol
    init(
        networkClient: FilmDetailNetworkProtocol,
        controller: FilmDetailControllerProtocol
    ) {
        self.networkClient = networkClient
        self.controller = controller
    }
}

extension FilmDetailPresenter: FilmDetailPresenterProtocol {
//    func configure() {
//
////        controller?.configure(with: item)
//    }
    
    func getData(item: Item) {
        networkClient.getDetails(id: item.id) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.controller?.configure(with: response)
                }
            case .failure(let error):
                print("")
//                self?.errorAlert(error: error)
            }
        }
    }
}
