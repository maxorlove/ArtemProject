//
//  FilmsGridPresenter.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 27.01.2023.
//

import UIKit

protocol FilmsGridPresenterProtocol: AnyObject {
    func loadData(for page: Int, sortStyle: SortEnum)
}

final class FilmsGridPresenter {
    weak var controller: FilmsGridViewControllerProtocol?
    private let networkClient: FilmsNetworkProtocol
    init(
        controller: FilmsGridViewControllerProtocol,
        networkClient: FilmsNetworkProtocol
    ) {
        self.controller = controller
        self.networkClient = networkClient
    }
}

extension FilmsGridPresenter: FilmsGridPresenterProtocol {
    func loadData(for page: Int, sortStyle: SortEnum) {
        switch sortStyle {
        case .def:
            networkClient.getPopularMovies(page: page) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.controller?.reloadDataSourse(response: response)
                case .failure(let error):
                    self?.controller?.errorAlert(error: error)
                }
            }
        case .topRated:
            networkClient.getTopRated(page: page) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.controller?.reloadDataSourse(response: response)
                case .failure(let error):
                    self?.controller?.errorAlert(error: error)
                }
            }
        case .popular:
            networkClient.getNowPlaying(page: page) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.controller?.reloadDataSourse(response: response)
                case .failure(let error):
                    self?.controller?.errorAlert(error: error)
                }
            }
        }
    }
}
