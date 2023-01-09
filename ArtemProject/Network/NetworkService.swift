//
//  NetworkService.swift
//  AviasalesTest
//
//  Created by Ivan Berkut on 01.05.2021.
//

import Foundation

protocol NetworkService {
    func getPopularMovies(page: Int, completion: @escaping(Result<AllFilmsResponce, ErrorModel>) -> Void) -> URLSessionDataTask
    func getTopRated(page: Int, completion: @escaping(Result<AllFilmsResponce, ErrorModel>) -> Void) -> URLSessionDataTask
    func getNowPlaying(page: Int, completion: @escaping(Result<AllFilmsResponce, ErrorModel>) -> Void) -> URLSessionDataTask
}

class NetworkServiceImpl: NetworkService {
    func getPopularMovies(page: Int, completion: @escaping(Result<AllFilmsResponce, ErrorModel>) -> Void) -> URLSessionDataTask {
        let request = ServiceManager.shared.sendRequest(request: PopularFilmsRequest(page: page), completion: completion)
        return request
    }
    
    func getTopRated(page: Int, completion: @escaping(Result<AllFilmsResponce, ErrorModel>) -> Void) -> URLSessionDataTask {
        let request = ServiceManager.shared.sendRequest(request: TopRatedFilmsRequest(page: page), completion: completion)
        return request
    }
    
    func getNowPlaying(page: Int, completion: @escaping(Result<AllFilmsResponce, ErrorModel>) -> Void) -> URLSessionDataTask {
        let request = ServiceManager.shared.sendRequest(request: NowPlayingFilmsRequest(page: page), completion: completion)
        return request
    }
}
