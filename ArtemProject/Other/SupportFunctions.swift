//
//  SupportFunctions.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 04.02.2023.
//

import UIKit

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

final class Rounder {
    static func roundDouble(_ x: Double) -> Float {
        let f = (x * 10).rounded() / 10
        return Float(f)
    }
}

final class ImageManager {
    static func saveImage(image: UIImage, name: String) -> URL? {
        guard let data = image.pngData() else { return nil }
        
        guard let path = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathExtension("\(name).png") else {
            print("path forming Error")
            return nil
        }
        
        do {
            try data.write(to: path)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        return path
    }
    
    static func getImage(url: URL) -> UIImage? {
        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            return image
        } catch let error {
            print(error.localizedDescription)
            return getPlaceholder()
        }
    }
    
    static func getPlaceholder() -> UIImage {
        if let image = UIImage(named: "photoPlaceholder") {
            return image
        }
        return UIImage()
    }
}
