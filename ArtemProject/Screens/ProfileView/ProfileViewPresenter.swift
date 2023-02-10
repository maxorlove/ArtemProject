//
//  ProfileViewPresenter.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 07.02.2023.
//

import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    func setupView()
    func didEditTaped()
    func saveProfileImage(image: Data)
    func saveAttValue(att: AttNameEnum, value: String)
    func saveAll()
}

class ProfileViewPresenter {
    weak var viewController: ProfileViewControllerProtocol?
    private var editState = false
    private var profileStruct: Profile?
    private let userDefaults: UserDefaultsServiceProtocol = UserDefaultsService(with: UserDefaults.standard)
    
    init(
        viewController: ProfileViewControllerProtocol
    ) {
        self.viewController = viewController
    }
}

extension ProfileViewPresenter: ProfileViewPresenterProtocol {
    func saveAll() {
        userDefaults.saveModel(profileStruct, by: .profile)
    }
    
    func saveAttValue(att: AttNameEnum, value: String) {
        guard var profileStruct = profileStruct else { return }
        switch att {
        case .name:
            profileStruct.name = value
        case .email:
            profileStruct.email = value
        case .title:
            profileStruct.title = value
        case .location:
            profileStruct.location = value
        }
        self.profileStruct = profileStruct
    }
    
    func saveProfileImage(image: Data) {
        guard var profileStruct = profileStruct else { return }
        profileStruct.image = image
        self.profileStruct = profileStruct
    }
    
    func setupView() {
        if let profileStruct = userDefaults.getModel(with: Profile.self, by: .profile) {
            self.profileStruct = profileStruct
            viewController?.configure(profileStruct: profileStruct)
        }
        viewController?.switchEdit(edit: editState)
    }
    
    func didEditTaped() {
        editState = !editState
        viewController?.switchEdit(edit: editState)
    }
}
