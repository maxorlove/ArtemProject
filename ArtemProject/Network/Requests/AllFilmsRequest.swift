//
//  AllCharactersRequest.swift
//  RickAndMorty
//
//  Created by Иван Беркут on 22.12.2022.
//

import Foundation

class AllFilmsRequest: RequestModel {

    private var page: Int

    init(page: Int) {
        self.page = page
    }

    override var path: String {
        return "api/character"
    }

    override var parameters: [String : Any?] {
        return [
            "page": page
        ]
    }

    override var method: RequestHTTPMethod {
        return .get
    }
}
