//
//  DetailsFilmResponse.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 22.01.2023.
//

import Foundation

struct DetailsFilmResponse: Codable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let posterPath: String?
    let budget: Int
    let genres: [Genre]
    let originalLanguage: String
    let title: String
    let overview: String
    let releaseDate: String
    let runtime: Int
    let status: String
    let tagline: String
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
}

struct Genre: Codable {
    let name: String
}
