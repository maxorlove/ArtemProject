//
//  TopRatedFilmsRequest.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 17.01.2023.
//

import Foundation

class TopRatedFilmsRequest: RequestModel {

    private var page: Int

    init(page: Int) {
        self.page = page
    }

    override var path: String {
        return "movie/top_rated"
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
