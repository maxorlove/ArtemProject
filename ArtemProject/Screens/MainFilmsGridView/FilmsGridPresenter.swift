//
//  FilmsGridPresenter.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 27.01.2023.
//

import UIKit

protocol FilmsGridPresenterProtocol: AnyObject {
    func loadData(isFinished: (() -> (Void))?)
    func getTotalPages() -> Int
    func getCurrentPage() -> Int
    func getNext() -> Bool
    func refreshPages()
    func didSortButtonPressed(sortStyle: SortEnum)
    func didSearchButtonPressed(text: String)
    func showDetails(item: Item)
    func likeDidTapped(id: Int)
}

final class FilmsGridPresenter {
    
    // MARK: - Public Properties
    weak var viewController: FilmsGridViewControllerProtocol?
    
    // MARK: - Private Properties
    private let router: FilmsGridRouterProtocol
    private let networkClient: FilmsNetworkProtocol
    private var currentSortStyle: SortEnum = .def
    private var currentPage: Int = 0
    private var totalPages: Int = 1
    
    // MARK: - Init/Deinit
    init(
        router: FilmsGridRouterProtocol,
        controller: FilmsGridViewControllerProtocol,
        networkClient: FilmsNetworkProtocol
    ) {
        self.router = router
        self.viewController = controller
        self.networkClient = networkClient
    }
}

// MARK: - Protocols
extension FilmsGridPresenter: FilmsGridPresenterProtocol {
    func likeDidTapped(id: Int) {
        LikesManager.addLikedFilm(id: id)
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
        viewController?.clearDataSource(sortStyle: .topRated)
        refreshPages()
        loadData(isFinished: { [weak self] in
            self?.viewController?.scrollToTop()
        })
    }
    
    func didSearchButtonPressed(text: String) {
        currentSortStyle = .searched
        viewController?.clearDataSource(sortStyle: .searched)
        loadSearchResult(text: text)
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
    
    func loadData(isFinished: (() -> (Void))? = nil) {
        currentPage += 1
        switch currentSortStyle {
        case .def:
            networkClient.getPopularMovies(page: currentPage) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.totalPages = response.totalPages
                    self?.viewController?.reloadDataSourse(response: response)
                    isFinished?()
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
                    isFinished?()
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
                    isFinished?()
                case .failure(let error):
                    self?.viewController?.errorAlert(error: error)
                }
            }
        case .searched:
            return
        }
    }
    
    func loadSearchResult(text: String) {
        networkClient.searchFilm(query: text) { [weak self] result in
            switch result {
            case .success(let response):
                self?.viewController?.reloadDataSourse(response: response)
            case .failure(let error):
                self?.viewController?.errorAlert(error: error)
            }
        }
    }
}
