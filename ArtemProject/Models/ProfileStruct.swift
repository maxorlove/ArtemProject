//
//  ProfileStruct.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 11.01.2023.
//

import UIKit

struct ProfileStruct {
    var name: String = ""
    var email: String = ""
    var title: String = ""
    var location: String = ""
    var image: UIImage = UIImage()
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
