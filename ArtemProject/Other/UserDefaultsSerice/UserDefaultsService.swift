// Copyright (c) 2022 Magic Solutions. All rights reserved.

import Foundation

public final class UserDefaultsService {

    // MARK: - Properties
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let userDefaults: UserDefaults

    // MARK: - Init/Deinit
    public init(with userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

// MARK: - UserDefaultsServiceProtocol
extension UserDefaultsService: UserDefaultsServiceProtocol {
    public func getModel<Model: Decodable>(with type: Model.Type, by key: UserDefaultsKey) -> Model? {
        if let model = userDefaults.object(forKey: key.rawValue) as? Data {
            if let decodedModel = try? decoder.decode(type, from: model) {
                return decodedModel
            }
        }
        return nil
    }
    
    public func saveModel(_ model: Encodable?, by key: UserDefaultsKey) {
        if let model = model, let encoded = try? encoder.encode(model) {
            userDefaults.set(encoded, forKey: key.rawValue)
        }
    }
    
    public func removeKeys(_ keys: [UserDefaultsKey]) {
        UserDefaultsKey
            .allCases
            .filter { keys.contains($0) }
            .forEach { userDefaults.set(nil, forKey: $0.rawValue) }
    }
    
    public func removeAll() {
        UserDefaultsKey.allCases.forEach {
            userDefaults.removeObject(forKey: $0.rawValue)
        }
    }
}
