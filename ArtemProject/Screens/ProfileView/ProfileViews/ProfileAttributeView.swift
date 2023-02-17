//
//  ProfileAttributeView.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 10.01.2023.
//

import UIKit

final class ProfileAttributeView: UIView {
    
    // MARK: - Public Properties
    var didEndEditAction: ((AttNameEnum, String) -> Void)?
    var type: AttNameEnum?
    
    // MARK: - Private Properties
    private let label = UILabel()
    private let value = UITextField()
    private let editButton = UIButton()
    private let separator = UIView()
    
    // MARK: - Init/Deinit
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private Methods
    private func setup() {
        value.delegate = self
        addSubViews()
        setupConstraints()
        setupLabels()
        setupButton()
        setupView()
    }
    
    private func addSubViews() {
        [label, value, editButton, separator].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -10),
            
            value.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            value.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            value.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            value.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -10),
            
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            editButton.heightAnchor.constraint(equalTo: editButton.widthAnchor),
            editButton.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupLabels() {
        label.font = .systemFont(ofSize: 24, weight: .regular)
        value.font = .systemFont(ofSize: 18, weight: .light)
        value.returnKeyType = .done
        value.isEnabled = false
    }
    
    private func setupButton() {
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.tintColor = .black
        editButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    private func setupView() {
        separator.backgroundColor = .systemFill
    }
    
    @objc
    private func buttonAction() {
        value.isEnabled = true
        value.becomeFirstResponder()
    }
    
    // MARK: - Public Methods
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

// MARK: - Delegates
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
