//
//  FilmsGridPresenter.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 27.01.2023.
//

import UIKit

protocol FilmsGridPresenterProtocol: AnyObject {
    func loadData()
    func getTotalPages() -> Int
    func getCurrentPage() -> Int
    func getNext() -> Bool
    func refreshPages()
    func didSortButtonPressed(sortStyle: SortEnum)
    func showDetails(item: Item)
}

final class FilmsGridPresenter {
    private let router: FilmsGridRouterProtocol?
    weak var controller: FilmsGridViewControllerProtocol?
    private let networkClient: FilmsNetworkProtocol
    
    private var currentSortStyle: SortEnum = .def
    private var currentPage: Int = 0
    private var totalPages: Int = 1
    
    init(
        router: FilmsGridRouterProtocol,
        controller: FilmsGridViewControllerProtocol,
        networkClient: FilmsNetworkProtocol
    ) {
        self.router = router
        self.controller = controller
        self.networkClient = networkClient
    }
}

extension FilmsGridPresenter: FilmsGridPresenterProtocol {
    func showDetails(item: Item) {
        router?.showFilmsDetailView(item: item)
    }
    
    func didSortButtonPressed(sortStyle: SortEnum) {
        currentSortStyle = sortStyle
        self.controller?.clearDataSource(sortStyle: .topRated)
        refreshPages()
        loadData()
    }
    
    func refreshPages() {
        currentPage = 0
        totalPages = 1
    }
    
    func getNext() -> Bool {
        return currentPage < totalPages
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func getTotalPages() -> Int {
        return totalPages
    }
    
    func loadData() {
        let page = currentPage + 1
        switch currentSortStyle {
        case .def:
            networkClient.getPopularMovies(page: page) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.totalPages = response.totalPages
                    self?.controller?.reloadDataSourse(response: response)
                case .failure(let error):
                    self?.controller?.errorAlert(error: error)
                }
            }
        case .topRated:
            networkClient.getTopRated(page: page) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.totalPages = response.totalPages
                    self?.controller?.reloadDataSourse(response: response)
                case .failure(let error):
                    self?.controller?.errorAlert(error: error)
                }
            }
        case .popular:
            networkClient.getNowPlaying(page: page) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.totalPages = response.totalPages
                    self?.controller?.reloadDataSourse(response: response)
                case .failure(let error):
                    self?.controller?.errorAlert(error: error)
                }
            }
        }
    }
}
