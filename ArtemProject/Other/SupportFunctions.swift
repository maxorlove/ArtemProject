//
//  SupportFunctions.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 04.02.2023.
//

import Foundation

final class LikesManager {
    static func addLikedFilm(id: Int) {
        let defaults = UserDefaults.standard
        if let likedFilms = defaults.array(forKey: "likedFilms") as? [Int] {
            var set = Set(likedFilms)
            if set.contains(id) {
                set.remove(id)
            } else {
                set.insert(id)
            }
            defaults.set(Array(set), forKey: "likedFilms")
        } else {
            var set: Set<Int> = Set()
            set.insert(id)
            defaults.set(Array(set), forKey: "likedFilms")
        }
    }
    
    static func checkLikedFilm(id: Int) -> Bool {
        let defaults = UserDefaults.standard
        if let likedFilms = defaults.array(forKey: "likedFilms") as? [Int] {
            let set = Set(likedFilms)
            if set.contains(id) {
                return true
            } else {
                return false
            }
        }
        return false
    }
}
