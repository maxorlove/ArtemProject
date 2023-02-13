//
//  ProfileStruct.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 11.01.2023.
//

import UIKit

struct Profile: Codable {
    var name: String?
    var email: String?
    var title: String?
    var location: String?
    var image: Data?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case email = "email"
        case title = "title"
        case location = "location"
        case image = "image"
    }
    
    init() {
        self.name = ""
        self.email = ""
        self.title = ""
        self.location = ""
        self.image = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try? container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.email = try? container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.title = try? container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.location = try? container.decodeIfPresent(String.self, forKey: .location) ?? ""
        self.image = try? container.decodeIfPresent(Data.self, forKey: .image)
    }
}

struct Likes: Codable {
    var id: [Int]
}

//struct ProfileStruct {
//    let name: String?
//    let email: String?
//    let title: String?
//    let location: String?
//    let image: UIImage?
//
//    init() {
//        let defaults = UserDefaults.standard
//        self.name = defaults.string(forKey: "name") ?? ""
//        self.email = defaults.string(forKey: "email") ?? ""
//        self.title = defaults.string(forKey: "title") ?? ""
//        self.location = defaults.string(forKey: "location") ?? ""
//        if let data = defaults.object(forKey: "image") as? Data,  let image = UIImage(data: data) {
//            self.image = image
//        } else {
//            self.image = UIImage()
//        }
//    }
//}
