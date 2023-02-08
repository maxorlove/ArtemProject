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
    private var profileStruct = Profile()
    private let title: String
    private let userDefaults: UserDefaultsServiceProtocol = UserDefaultsService(with: UserDefaults.standard)
    
    init(
        viewController: ProfileViewControllerProtocol,
        title: String
    ) {
        self.viewController = viewController
        self.title = title
    }
}

extension ProfileViewPresenter: ProfileViewPresenterProtocol {
    func saveAll() {
        userDefaults.saveModel(profileStruct, by: .profile)
    }
    
    func saveAttValue(att: AttNameEnum, value: String) {
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
    }
    
    func saveProfileImage(image: Data) {
        profileStruct.image = image
    }
    
    
    func setupView() {
        if let profileStruct = userDefaults.getModel(with: Profile.self, by: .profile) {
            self.profileStruct = profileStruct
        }
        viewController?.setViewTitle(title: title)
        viewController?.configure(profileStruct: profileStruct)
        viewController?.switchEdit(edit: editState)
    }
    
    func didEditTaped() {
        editState = !editState
        viewController?.switchEdit(edit: editState)
    }
}
