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
    func saveProfileImage(url: URL)
    func saveAttValue(att: AttNameEnum, value: String)
    func saveAll()
}

final class ProfileViewPresenter {
    
    // MARK: - Public Properties
    weak var viewController: ProfileViewControllerProtocol?
    
    // MARK: - Private Properties
    private let router: ProfileViewRouterProtocol
    private let userDefaults: UserDefaultsServiceProtocol = UserDefaultsService(with: UserDefaults.standard)
    private var editState = false
    private var profileStruct = Profile()
    
    // MARK: - Init/Deinit
    init(
        router: ProfileViewRouterProtocol,
        viewController: ProfileViewControllerProtocol
    ) {
        self.router = router
        self.viewController = viewController
        
    }
}

// MARK: - Protocols
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
    
    func saveProfileImage(url: URL) {
        profileStruct.image = url
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
