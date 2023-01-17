//
//  ProfileHeaderView.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 10.01.2023.
//

import UIKit

class ProfileHeaderView: UIView {
    
    private var editFlag: Bool = false
    private let label = UILabel()
    private let image = UIImageView()
    private let editButton = UIButton()
    private let imageEditButton = UIButton()
    var actionPressed: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        backgroundColor = .lightGray
        addSubViews()
        setupConstraints()
        setupLabels()
        setupImages()
        setEditFlag(edit: editFlag)
    }
    
    private func addSubViews() {
        [label, image, editButton, imageEditButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.5),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            
            imageEditButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageEditButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageEditButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.5),
            imageEditButton.heightAnchor.constraint(equalTo: image.widthAnchor),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 40),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            editButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            editButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 10),
            editButton.heightAnchor.constraint(equalTo: editButton.widthAnchor)
        ])
    }
    
    private func setupLabels() {
        label.text = "PROFILE PHOTO"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
    }
    
    private func setupImages() {
        image.backgroundColor = .black
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = (UIScreen.main.bounds.width / 2.5) / 2
    }
    
    private func setupButton() {
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.tintColor = .black
        editButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        editButton.isHidden = !editFlag
        editButton.isEnabled = editFlag
        
        imageEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        imageEditButton.tintColor = .white
        imageEditButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        imageEditButton.isHidden = !editFlag
        imageEditButton.isEnabled = editFlag
        imageEditButton.layer.masksToBounds = true
        imageEditButton.contentMode = .scaleToFill
        imageEditButton.layer.cornerRadius = (UIScreen.main.bounds.width / 2.5) / 2
    }
    
    func setEditFlag(edit: Bool) {
        editFlag = edit
        setupButton()
    }
    
    @objc
    private func buttonAction() {
        actionPressed?()
    }
    
    func setImage(image: UIImage) {
        self.image.image = image
    }
}
