//
//  ProfileAttributeView.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 10.01.2023.
//

import UIKit

final class ProfileAttributeView: UIView {
    
    var didEndEditAction: ((AttNameEnum, String) -> Void)?
    var type: AttNameEnum?
    
    private let label = UILabel()
    private let value = UITextField()
    private let editButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        value.delegate = self
        addSubViews()
        setupConstraints()
        setupLabels()
        setupButton()
    }
    
    private func addSubViews() {
        [label, value, editButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            label.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -10),
            
            value.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            value.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3),
            value.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            value.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -10),
            
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            editButton.heightAnchor.constraint(equalTo: editButton.widthAnchor),
            editButton.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
        ])
    }
    
    private func setupLabels() {
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        value.font = .systemFont(ofSize: 18, weight: .light)
        value.returnKeyType = .done
        value.isEnabled = false
    }
    
    private func setupButton() {
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.tintColor = .black
        editButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc
    private func buttonAction() {
        value.isEnabled = true
        value.becomeFirstResponder()
    }
    
    func configure(type: AttNameEnum) {
        self.label.text = type.rawValue
        self.value.placeholder = "\(type)"
        self.type = type
    }
    
    func setLabel(profileStruct: Profile) {
        guard let type = type else { return }
        switch type {
        case .name:
            self.value.text = profileStruct.name
        case .email:
            self.value.text = profileStruct.email
        case .title:
            self.value.text = profileStruct.title
        case .location:
            self.value.text = profileStruct.location
        }
    }
    
    func showButtons(edit: Bool) {
        editButton.isHidden = !edit
        editButton.isEnabled = edit
    }
}

extension ProfileAttributeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let type = self.type else { return }
        value.isEnabled = false
        let text = value.text
        didEndEditAction?(type, text ?? "")
    }
}
