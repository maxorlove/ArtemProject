//
//  AllFilmsResponce.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 07.01.2023.
//

import Foundation

struct AllFilmsResponce: Codable {
    let results: [Item]
//    let total_pages: Int
}

struct Item: Codable {
    let id: Int
    let title: String
}
