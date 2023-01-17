//
//  ProfileAttributeView.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 10.01.2023.
//

import UIKit

class ProfileAttributeView: UIView {
    
    var didEndEditAction: ((AttNameEnum, String) -> Void)?
    var type: AttNameEnum?
    
    let defaults = UserDefaults.standard
    private let label = UILabel()
    private let value = UITextField()
    private let editButton = UIButton()
    private var editFlag = false
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        self.value.delegate = self
        addSubViews()
        setupConstraints()
        setupLabels()
        setupButton()
        setupViews()
    }
    
    private func addSubViews() {
        [label, value, editButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            label.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -10),
            
            value.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            value.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3),
            value.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            value.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -10),
            
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            editButton.heightAnchor.constraint(equalTo: editButton.widthAnchor),
            editButton.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            editButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
        ])
    }
    
    private func setupLabels() {
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        value.font = .systemFont(ofSize: 18, weight: .light)
    }
    
    private func setupButton() {
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.tintColor = .black
        editButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        editButton.isHidden = !editFlag
        editButton.isEnabled = editFlag
    }
    
    @objc
    private func buttonAction() {
        value.isEnabled = true
        value.becomeFirstResponder()
    }
    
    func setEditFlag(edit: Bool) {
        editFlag = edit
        editButton.isHidden = !editFlag
        editButton.isEnabled = editFlag
    }
    
    func configure(type: AttNameEnum) {
        self.label.text = type.rawValue
        self.type = type
        switch type {
        case .name:
            setLabel(type: type)
        case .email:
            setLabel(type: type)
        case .title:
            setLabel(type: type)
        case .location:
            setLabel(type: type)
        }
    }
    
    private func setLabel(type: AttNameEnum) {
        if let savedValue = defaults.string(forKey: "\(type)") {
            self.value.text = savedValue
            self.didEndEditAction?(type, savedValue)
        } else {
            self.value.placeholder = "\(type)"
        }
    }
    
    private func setupViews() {
        value.isEnabled = false
        value.returnKeyType = .done
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
