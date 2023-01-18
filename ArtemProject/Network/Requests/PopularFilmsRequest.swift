//
//  AllCharactersRequest.swift
//  RickAndMorty
//
//  Created by Иван Беркут on 22.12.2022.
//

import Foundation

class PopularFilmsRequest: RequestModel {

    private var page: Int

    init(page: Int) {
        self.page = page
    }

    override var path: String {
        return "movie/popular"
    }

    override var parameters: [String : Any?] {
        return [
            "api_key": "e7cd6cd3c324af8138cb9d0d998c2cc6",
            "language": "en-US",
            "page": page
        ]
    }

    override var method: RequestHTTPMethod {
        return .get
    }
}

