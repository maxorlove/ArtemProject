//
//  FilmDetailPresenter.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 27.01.2023.
//

import Foundation

protocol FilmDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func setupLikeButton()
    func likeDidTapped()
    func popOut()
    func getNewSimilarFilms()
    func showDetails(item: DetailDataStruct)
}

class FilmDetailPresenter {
    
    // MARK: - Public Properties
    weak var viewController: FilmDetailControllerProtocol?
    
    // MARK: - Private Properties
    private let dispatchGroup = DispatchGroup()
    private let router: FilmDetailRouterProtocol
    private let networkClient: FilmDetailNetworkProtocol
    private let data: DetailDataStruct
    private var similarFilmsPage = 0
    private var similarFilmsPageCount = 0
    private var response: DetailsFilmResponse?
    private var similarResponce: AllFilmsResponse?
    
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
    
    private func loadData() {
        let id = data.id
        dispatchGroup.enter()
        networkClient.getDetails(id: id) { [weak self] result in
            switch result {
            case .success(let response):
                self?.response = response
            case .failure(let error):
                self?.viewController?.errorAlert(error: error)
            }
            self?.dispatchGroup.leave()
        }
    }
    
    private func getSimilarFilms() {
        let id = data.id
        similarFilmsPage += 1
        dispatchGroup.enter()
        networkClient.getSimilar(id: id, page: similarFilmsPage) { [weak self] result in
            switch result {
            case .success(let response):
                self?.similarResponce = response
            case .failure(let error):
                self?.viewController?.errorAlert(error: error)
            }
            self?.dispatchGroup.leave()
        }
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
    
    func viewDidLoad() {
        loadData()
        getSimilarFilms()
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self,
                  let response = self.response,
                  let similarResponce = self.similarResponce
            else { return }
            
            self.viewController?.configure(with: response)
            
            self.similarFilmsPageCount = similarResponce.totalPages
            if similarResponce.totalPages >= self.similarFilmsPage {
                self.viewController?.addSimilarFilms(items: similarResponce.results)
            }
        }
    }
    
    func getNewSimilarFilms() {
        getSimilarFilms()
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self,
                  let similarResponce = self.similarResponce
            else { return }
            
            self.similarFilmsPageCount = similarResponce.totalPages
            if similarResponce.totalPages >= self.similarFilmsPage {
                self.viewController?.addSimilarFilms(items: similarResponce.results)
            }
        }
    }
    
    func popOut() {
        router.popOutView()
    }
}
