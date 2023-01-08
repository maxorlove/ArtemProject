//
//  AllFilmsResponce.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 07.01.2023.
//

import Foundation

struct AllFilmsResponce: Codable {
    let results: [Item]
    let totalPages: Int
}

struct Item: Codable {
    let id: Int
    let title: String
    let adult: Bool
    let backdropPath: String?
    let overview: String
    let voteAverage: Double
    let releaseDate: String
    let posterPath: String?
}
