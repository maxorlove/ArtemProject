//
//  ProfileHeaderView.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 10.01.2023.
//

import UIKit

final class ProfileHeaderView: UIView {
    
    // MARK: - Public Properties
    var actionPressed: (() -> Void)?
    
    // MARK: - Private Properties
    private let label = UILabel()
    private let image = UIImageView()
    private let editButton = UIButton()
    private let imageEditButton = UIButton()
    
    // MARK: - Init/Deinit
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private Methods
    private func setup() {
        addSubViews()
        setupConstraints()
        setupViews()
        setupLabels()
        setupImages()
        setupButtons()
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
            
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 32),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            editButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            editButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 10),
            editButton.heightAnchor.constraint(equalTo: editButton.widthAnchor)
        ])
    }
    
    private func setupViews() {
        backgroundColor = .white
    }
    
    private func setupLabels() {
        label.text = "PROFILE PHOTO"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
    }
    
    private func setupImages() {
        image.backgroundColor = Colors.secondarySurfaceColor
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = (UIScreen.main.bounds.width / 2.5) / 2
    }
    
    private func setupButtons() {
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.tintColor = .black
        editButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        imageEditButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        imageEditButton.tintColor = .white
        imageEditButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        imageEditButton.layer.masksToBounds = true
        imageEditButton.contentMode = .scaleToFill
        imageEditButton.layer.cornerRadius = (UIScreen.main.bounds.width / 2.5) / 2
    }
    
    @objc
    private func buttonAction() {
        actionPressed?()
    }
    
    // MARK: - Public Methods
    func showButtons(edit: Bool) {
        editButton.isHidden = !edit
        editButton.isEnabled = edit
        imageEditButton.isHidden = !edit
        imageEditButton.isEnabled = edit
    }

    func setImage(image: UIImage) {
        self.image.image = image
    }
}
