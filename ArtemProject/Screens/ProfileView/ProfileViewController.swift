//
//  ProfileViewController.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 07.01.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //    MARK: - properties
    var didEndEdit: ((ProfileStruct) -> Void)?
    
    private var editFlag = false
    private let headerView = ProfileHeaderView()
    private let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }()
    private var stackTopAnchor: NSLayoutConstraint!
    
    private var profileStruct: ProfileStruct = {
        var profile = ProfileStruct()
        let defaults = UserDefaults.standard
        AttNameEnum.allCases.forEach {
            switch $0 {
            case .name:
                if let savedValue = defaults.string(forKey: "\($0)") {
                    profile.name = savedValue
                }
            case .email:
                if let savedValue = defaults.string(forKey: "\($0)") {
                    profile.email = savedValue
                }
            case .title:
                if let savedValue = defaults.string(forKey: "\($0)") {
                    profile.title = savedValue
                }
            case .location:
                if let savedValue = defaults.string(forKey: "\($0)") {
                    profile.location = savedValue
                }
            }
        }
        if let data = defaults.object(forKey: "image") as? Data,  let image = UIImage(data: data) {
            profile.image = image
        }
        return profile
    }()
    
    var endEdit: ((ProfileStruct) -> Void)?
    
    //    MARK: - main funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setup() {
        addSubViews()
        setupConstraints()
        setupViews()
        addStackViews()
    }
    
    private func addSubViews() {
        [headerView, verticalStackView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(lessThanOrEqualToConstant: ViewConstants.frameWidth),
            
            verticalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        stackTopAnchor = verticalStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8)
        stackTopAnchor.isActive = true
    }
    
    func setupViews() {
        view.backgroundColor = .white
        verticalStackView.backgroundColor = .lightGray
        headerView.setEditFlag(edit: editFlag)
        if editFlag {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", image: nil, target: self, action: #selector(doneEdit))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", image: nil, target: self, action: #selector(swichEdit))
        }
        
        headerView.actionPressed = {[weak self] in
            ImagePickerManager().pickImage(self!){ image in
                self?.headerView.setImage(image: image)
                self?.profileStruct.image = image
                }
        }
        updateHeaderView()
    }
    
    private func addStackViews() {
        AttNameEnum.allCases.forEach {
            let att = createProfileAttribute(att: $0)
            att.setEditFlag(edit: editFlag)
            verticalStackView.addArrangedSubview(att)
        }
    }
    
    private func prep(attType: AttNameEnum, textValue: String) {
        switch attType {
        case .name:
            profileStruct.name = textValue
        case .email:
            profileStruct.email = textValue
        case .title:
            profileStruct.title = textValue
        case .location:
            profileStruct.location = textValue
        }
    }
    
    private func createProfileAttribute(att: AttNameEnum) -> ProfileAttributeView {
        let view = ProfileAttributeView()
        view.didEndEditAction = {[weak self] attType, textValue in
            self?.prep(attType: attType, textValue: textValue)
        }
        view.configure(type: att)
        return view
    }
    
    //    MARK: - func
    func setEditFlag(edit: Bool) {
        editFlag = edit
    }
    
    func setViewTitle(title: String) {
        self.title = title
    }
    
    func saveAttValues() {
        let defaults = UserDefaults.standard
        defaults.set(profileStruct.name, forKey: "name")
        defaults.set(profileStruct.email, forKey: "email")
        defaults.set(profileStruct.title, forKey: "title")
        defaults.set(profileStruct.location, forKey: "location")
        if let data = profileStruct.image.pngData() {
            defaults.set(data, forKey: "image")
        }
    }
    
    func updateStackView() {
        verticalStackView.arrangedSubviews.forEach {
            if let sv = $0 as? ProfileAttributeView, let type = sv.type {
                sv.configure(type: type)
            }
        }
    }
    
    func updateHeaderView() {
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: "image") as? Data,  let image = UIImage(data: data) {
            headerView.setImage(image: image)
        }
    }
    
    @objc
    func swichEdit() {
        let editViewController = ProfileViewController()
        editViewController.setEditFlag(edit: true)
        editViewController.setViewTitle(title: "Edit profile")
        editViewController.didEndEdit = { [weak self] str in
            self?.profileStruct = str
            self?.saveAttValues()
            self?.updateStackView()
            self?.updateHeaderView()
        }
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    @objc
    func doneEdit() {
        if checkAllProperties() {
            didEndEdit?(profileStruct)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Fill all attributes", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkAllProperties() -> Bool {
        if profileStruct.name != "", profileStruct.email != "", profileStruct.location != "", profileStruct.title != "" {
            return true
        }
        return false
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y = 0 - keyboardHeight
            stackTopAnchor = verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: keyboardHeight)
            stackTopAnchor.isActive = true
            headerView.isHidden = true
        }
    }
    
    @objc
    func keyboardWillHide() {
        self.view.frame.origin.y = 0
        stackTopAnchor = verticalStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8)
        stackTopAnchor.isActive = true
        headerView.isHidden = false
    }
}

enum ViewConstants {
    static let frameWidth = UIScreen.main.bounds.width
}
