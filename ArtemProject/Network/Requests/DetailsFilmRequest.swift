//
//  DetailsFilmRequest.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 22.01.2023.
//

import Foundation

class DetailsFilmRequest: RequestModel {

    private var id: Int

    init(id: Int) {
        self.id = id
    }

    override var path: String {
        return "movie/\(id)"
    }

    override var parameters: [String : Any?] {
        return [
            "api_key": "e7cd6cd3c324af8138cb9d0d998c2cc6",
            "language": "en-US",
        ]
    }

    override var method: RequestHTTPMethod {
        return .get
    }
}
