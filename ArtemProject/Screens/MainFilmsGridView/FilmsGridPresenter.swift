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
    func setTitle()
    func likeDidTapped(id: Int)
}

final class FilmsGridPresenter {
    private let title: String
    private let router: FilmsGridRouterProtocol
    weak var viewController: FilmsGridViewControllerProtocol?
    private let networkClient: FilmsNetworkProtocol
    
    private var currentSortStyle: SortEnum = .def
    private var currentPage: Int = 0
    private var totalPages: Int = 1
    
    init(
        router: FilmsGridRouterProtocol,
        controller: FilmsGridViewControllerProtocol,
        networkClient: FilmsNetworkProtocol,
        title: String
    ) {
        self.router = router
        self.viewController = controller
        self.networkClient = networkClient
        self.title = title
    }
}

extension FilmsGridPresenter: FilmsGridPresenterProtocol {
    func likeDidTapped(id: Int) {
        SupportFunctions.addLikedFilm(id: id)
    }
    
    func setTitle() {
        viewController?.setViewTitle(title: title)
    }
    
    func showDetails(item: Item) {
        var data = DetailDataStruct.init(id: item.id)
        data.callBack = { [weak self] id in
            self?.viewController?.updateCell(index: id)
        }
        router.showFilmsDetailView(data: data)
    }
    
    func didSortButtonPressed(sortStyle: SortEnum) {
        currentSortStyle = sortStyle
        self.viewController?.clearDataSource(sortStyle: .topRated)
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
        currentPage += 1
        switch currentSortStyle {
        case .def:
            networkClient.getPopularMovies(page: currentPage) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.totalPages = response.totalPages
                    self?.viewController?.reloadDataSourse(response: response)
                case .failure(let error):
                    self?.viewController?.errorAlert(error: error)
                }
            }
        case .topRated:
            networkClient.getTopRated(page: currentPage) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.totalPages = response.totalPages
                    self?.viewController?.reloadDataSourse(response: response)
                case .failure(let error):
                    self?.viewController?.errorAlert(error: error)
                }
            }
        case .popular:
            networkClient.getNowPlaying(page: currentPage) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.totalPages = response.totalPages
                    self?.viewController?.reloadDataSourse(response: response)
                case .failure(let error):
                    self?.viewController?.errorAlert(error: error)
                }
            }
        }
    }
}
