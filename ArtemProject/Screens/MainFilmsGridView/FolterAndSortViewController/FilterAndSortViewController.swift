//
//  FilterAndSortViewController.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 09.01.2023.
//

import UIKit

class SortView: UIView {
    
    let label = UILabel()
    let button = UIButton()
    let sortLabel = UILabel()
    let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .vertical
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        addSubviews()
        setupConstraints()
        setupViews()
        setupButton()
    }
    
    func addSubviews() {
        [label, button, sortLabel, verticalStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            
            button.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            
            sortLabel.leadingAnchor.constraint(equalTo: button.trailingAnchor),
            sortLabel.topAnchor.constraint(equalTo: topAnchor),
            sortLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: sortLabel.bottomAnchor)
        ])
    }
    
    func setupViews() {
        label.text = "Sorted by:"
        label.textColor = .white
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sortLabel.text = "Default"
        sortLabel.textColor = .white
    }
    
    func setupButton() {
        button.addTarget(self, action: #selector(buttonAction), for: .touchDown)
    }
    
    @objc func buttonAction() {
        let alert = UIAlertController(title: "Notice", message: "Lauching this missile will destroy the entire universe. Is this what you intended to do?", preferredStyle: UIAlertController.Style.alert)

         // add the actions (buttons)
         alert.addAction(UIAlertAction(title: "Remind Me Tomorrow", style: UIAlertAction.Style.default, handler: nil))
         alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
         alert.addAction(UIAlertAction(title: "Launch the Missile", style: UIAlertAction.Style.destructive, handler: nil))

         // show the alert
//         self.present(alert, animated: true, completion: nil)
    }
}
