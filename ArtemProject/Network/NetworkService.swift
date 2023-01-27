//
//  NetworkService.swift
//  AviasalesTest
//
//  Created by Ivan Berkut on 01.05.2021.
//

import Foundation

protocol FilmsNetworkProtocol {
    func getPopularMovies(page: Int, completion: @escaping(Result<AllFilmsResponse, ErrorModel>) -> Void) -> URLSessionDataTask
    func getTopRated(page: Int, completion: @escaping(Result<AllFilmsResponse, ErrorModel>) -> Void) -> URLSessionDataTask
    func getNowPlaying(page: Int, completion: @escaping(Result<AllFilmsResponse, ErrorModel>) -> Void) -> URLSessionDataTask
}

protocol FilmDetailNetworkProtocol {
    func getDetails(id: Int, completion: @escaping(Result<DetailsFilmResponse, ErrorModel>) -> Void) -> URLSessionDataTask
}

final class NetworkService {}

extension NetworkService: FilmsNetworkProtocol {
    func getPopularMovies(page: Int, completion: @escaping(Result<AllFilmsResponse, ErrorModel>) -> Void) -> URLSessionDataTask {
        let request = ServiceManager.shared.sendRequest(request: PopularFilmsRequest(page: page), completion: completion)
        return request
    }
    
    func getTopRated(page: Int, completion: @escaping(Result<AllFilmsResponse, ErrorModel>) -> Void) -> URLSessionDataTask {
        let request = ServiceManager.shared.sendRequest(request: TopRatedFilmsRequest(page: page), completion: completion)
        return request
    }
    
    func getNowPlaying(page: Int, completion: @escaping(Result<AllFilmsResponse, ErrorModel>) -> Void) -> URLSessionDataTask {
        let request = ServiceManager.shared.sendRequest(request: NowPlayingFilmsRequest(page: page), completion: completion)
        return request
    }
}

extension NetworkService: FilmDetailNetworkProtocol {
    func getDetails(id: Int, completion: @escaping(Result<DetailsFilmResponse, ErrorModel>) -> Void) -> URLSessionDataTask {
        let request = ServiceManager.shared.sendRequest(request: DetailsFilmRequest(id: id), completion: completion)
        return request
    }
}
