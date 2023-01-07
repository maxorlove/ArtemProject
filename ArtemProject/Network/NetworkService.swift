//
//  NetworkService.swift
//  AviasalesTest
//
//  Created by Ivan Berkut on 01.05.2021.
//

import Foundation

protocol NetworkService {
    func allCharacters(page: Int, completion: @escaping(Result<AllFilmsResponce, ErrorModel>) -> Void) -> URLSessionDataTask
}

class NetworkServiceImpl: NetworkService {

    func allCharacters(page: Int, completion: @escaping(Result<AllFilmsResponce, ErrorModel>) -> Void) -> URLSessionDataTask {
        let request = ServiceManager.shared.sendRequest(request: AllFilmsRequest(page: page), completion: completion)
        return request
    }

}
