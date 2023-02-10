//
//  SimilarFilmsRequest.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 09.02.2023.
//

import Foundation

class SimilarFilmsRequest: RequestModel {

    private var id: Int
    private var page: Int

    init(id: Int, page: Int) {
        self.id = id
        self.page = page
    }

    override var path: String {
        return "movie/\(id)/similar"
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
