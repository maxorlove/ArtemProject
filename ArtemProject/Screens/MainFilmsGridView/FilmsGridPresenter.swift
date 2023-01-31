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
    func setSortStyle(sortStyle: SortEnum)
}

final class FilmsGridPresenter {
    weak var controller: FilmsGridViewControllerProtocol?
    private let networkClient: FilmsNetworkProtocol
    
    private var currentSortStyle: SortEnum = .def
    private var currentPage: Int = 0
    private var totalPages: Int = 1
    
    init(
        controller: FilmsGridViewControllerProtocol,
        networkClient: FilmsNetworkProtocol
    ) {
        self.controller = controller
        self.networkClient = networkClient
    }
}

extension FilmsGridPresenter: FilmsGridPresenterProtocol {
    func setSortStyle(sortStyle: SortEnum) {
        currentSortStyle = sortStyle
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
