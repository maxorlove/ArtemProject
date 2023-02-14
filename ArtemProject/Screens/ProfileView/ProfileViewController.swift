//
//  ProfileViewController.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 07.01.2023.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    func configure(profileStruct: Profile)
    func switchEdit(edit: Bool)
}

final class ProfileViewController: UIViewController {
    var presenter: ProfileViewPresenterProtocol?
    
    private let headerView = ProfileHeaderView()
    private let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }()
    private let imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        return UIImagePickerController()
    }()
    
    private var stackTopAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.setupView()
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
    
    private func setupViews() {
        view.backgroundColor = Colors.primaryBackgroundColor
        self.navigationItem.title = "Profile"
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        headerView.actionPressed = {[weak self] in
            self?.showPickerAllert()
        }
    }
    
    private func showPickerAllert() {
        var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.pickImage(.camera)
        })
        alert.addAction(UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.pickImage(.gallery)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        })
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func pickImage(_ style: PickerStyle) {
        switch style {
        case .camera:
            imagePicker.sourceType = .camera
        case .gallery:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func addStackViews() {
        AttNameEnum.allCases.forEach {
            let att = createProfileAttribute(att: $0)
            verticalStackView.addArrangedSubview(att)
        }
    }
    
    private func createProfileAttribute(att: AttNameEnum) -> ProfileAttributeView {
        let view = ProfileAttributeView()
        view.configure(type: att)
        view.didEndEditAction = { [weak self] (att, value) in
            self?.presenter?.saveAttValue(att: att, value: value)
        }
        return view
    }
    
    private func updateHeaderView(profileStruct: Profile) {
        if let data = profileStruct.image, let image = UIImage(data: data) {
            headerView.setImage(image: image)
        }
    }
    
    private func updateStackViews(profileStruct: Profile) {
        verticalStackView.arrangedSubviews.forEach {
            if let sv = $0 as? ProfileAttributeView {
                updateStackView(sv: sv, profileStruct: profileStruct)
            }
        }
    }
    
    private func updateStackView(sv: ProfileAttributeView, profileStruct: Profile) {
        sv.setLabel(profileStruct: profileStruct)
    }
    
    private func updateAccessibility(edit: Bool) {
        headerView.showButtons(edit: edit)
        verticalStackView.arrangedSubviews.forEach {
            if let sv = $0 as? ProfileAttributeView {
                sv.showButtons(edit: edit)
            }
        }
    }
    
    private func collectAndSave() {
        presenter?.saveAll()
    }
    
    @objc
    private func didEditTaped() {
        presenter?.didEditTaped()
    }
    
    @objc
    private func didSaveTaped() {
        collectAndSave()
        presenter?.didEditTaped()
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
            navigationItem.rightBarButtonItem?.isHidden = true
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc
    func keyboardWillHide() {
        self.view.frame.origin.y = 0
        stackTopAnchor = verticalStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8)
        stackTopAnchor.isActive = true
        headerView.isHidden = false
        navigationItem.rightBarButtonItem?.isHidden = false
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

private enum ViewConstants {
    static let frameWidth = UIScreen.main.bounds.width
}

private enum PickerStyle {
    case camera
    case gallery
}

extension ProfileViewController: ProfileViewControllerProtocol {
    
    func configure(profileStruct: Profile) {
        updateHeaderView(profileStruct: profileStruct)
        updateStackViews(profileStruct: profileStruct)
    }
    
    func switchEdit(edit: Bool) {
        if edit {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", image: nil, target: self, action: #selector(didSaveTaped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", image: nil, target: self, action: #selector(didEditTaped))
        }
        updateAccessibility(edit: edit)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        headerView.setImage(image: image)
        if let data = image.pngData() {
            presenter?.saveProfileImage(image: data)
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
}
