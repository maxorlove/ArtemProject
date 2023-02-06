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
}

class FilmDetailPresenter {
    weak var viewController: FilmDetailControllerProtocol?
    private let router: FilmDetailRouterProtocol
    private let networkClient: FilmDetailNetworkProtocol
    private let data: DetailDataStruct
    
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

extension FilmDetailPresenter: FilmDetailPresenterProtocol {
    func likeDidTapped() {
        SupportFunctions.addLikedFilm(id: data.id)
        setupLikeButton()
        data.callBack?(data.id)
    }
    
    func setupLikeButton() {
        viewController?.setupLikeButton(isLiked: SupportFunctions.checkLikedFilm(id: data.id))
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
    
    func popOut() {
        router.popOutView()
    }
}
