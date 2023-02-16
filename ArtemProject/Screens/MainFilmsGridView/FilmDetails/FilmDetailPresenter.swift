//
//  FilmDetailPresenter.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 27.01.2023.
//

import Foundation

protocol FilmDetailPresenterProtocol: AnyObject {
    func loadData()
    func setupLikeButton()
    func likeDidTapped()
    func popOut()
    func getSimilarFilms(firstLoad: (() -> (Void))?)
    func showDetails(item: DetailDataStruct)
}

class FilmDetailPresenter {
    
    // MARK: - Public Properties
    weak var viewController: FilmDetailControllerProtocol?
    
    // MARK: - Private Properties
    private let router: FilmDetailRouterProtocol
    private let networkClient: FilmDetailNetworkProtocol
    private let data: DetailDataStruct
    private var similarFilmsPage = 0
    private var similarFilmsPageCount = 0
    
    // MARK: - Init/Deinit
    init(
        networkClient: FilmDetailNetworkProtocol,
        controller: FilmDetailControllerProtocol,
        router: FilmDetailRouterProtocol,
        data: DetailDataStruct
    ) {
        self.networkClient = networkClient
        self.viewController = controller
        self.router = router
        self.data = data
    }
}

// MARK: - Protocols
extension FilmDetailPresenter: FilmDetailPresenterProtocol {
    func showDetails(item: DetailDataStruct) {
        var data = DetailDataStruct(id: item.id)
        data.callBack = self.data.callBack
        data.callBack2 = item.callBack
        router.showFilmsDetailView(data: data)
    }
    
    func likeDidTapped() {
        LikesManager.addLikedFilm(id: data.id)
        setupLikeButton()
        data.callBack?(data.id)
        data.callBack2?(data.id)
    }
    
    func setupLikeButton() {
        viewController?.setupLikeButton(isLiked: LikesManager.checkLikedFilm(id: data.id))
    }
    
    func loadData() {
        let id = data.id
        networkClient.getDetails(id: id) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.viewController?.configure(with: response)
                }
            case .failure(let error):
                self?.viewController?.errorAlert(error: error)
            }
        }
    }
    
    func getSimilarFilms(firstLoad: (() -> (Void))? = nil) {
        let id = data.id
        similarFilmsPage += 1
        networkClient.getSimilar(id: id, page: similarFilmsPage) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response.results.count > 0 {
                        firstLoad?()
                    }
                    self?.similarFilmsPageCount = response.totalPages
                    if response.totalPages >= self?.similarFilmsPage ?? 0 {
                        self?.viewController?.addSimilarFilms(items: response.results)
                    }
                }
            case .failure(let error):
                self?.viewController?.errorAlert(error: error)
            }
        }
    }
    
    func popOut() {
        router.popOutView()
    }
}
