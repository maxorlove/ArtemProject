// Copyright (c) 2022 Magic Solutions. All rights reserved.

import Foundation

public protocol UserDefaultsServiceProtocol {
    func saveModel(_ model: Encodable?, by key: UserDefaultsKey)
    func getModel<Model: Decodable>(with type: Model.Type, by key: UserDefaultsKey) -> Model?
    func removeKeys(_ keys: [UserDefaultsKey])
    func removeAll()
}
