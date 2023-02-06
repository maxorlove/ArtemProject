//
//  DataStruct.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 02.02.2023.
//

import Foundation

struct DetailDataStruct {
    let id: Int
    var callBack: ((Int) -> ())?
    
    init(id: Int) {
        self.id = id
    }
}
