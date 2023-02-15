//
//  MainEnums.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 09.01.2023.
//

import Foundation

enum SortEnum: String, CaseIterable {
    case topRated = "Top rated"
    case popular = "Popular"
    case def = "Default"
    case searched = "Searched"
}

enum AttNameEnum: String, CaseIterable {
    case name = "NAME"
    case email = "EMAIL"
    case title = "TITLE"
    case location = "LOCATION"
}

enum GridType: Int {
    case single = 1
    case double = 2
}

