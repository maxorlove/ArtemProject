//
//  SearchFilmRequest.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 14.02.2023.
//

import Foundation

class SearchFilmRequest: RequestModel {

    private var query: String

    init(query: String) {
        self.query = query
    }

    override var path: String {
        return "search/movie"
    }

    override var parameters: [String : Any?] {
        return [
            "api_key": "e7cd6cd3c324af8138cb9d0d998c2cc6",
            "query": query
        ]
    }

    override var method: RequestHTTPMethod {
        return .get
    }
}
