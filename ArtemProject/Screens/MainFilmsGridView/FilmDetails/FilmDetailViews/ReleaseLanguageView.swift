//
//  ReleaseLanguageView.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 16.02.2023.
//

import UIKit

final class ReleaseLanguageView: UIView {
    
    //MARK: - private properties
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 16
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    //MARK: - private functions
    private func setup() {
        addSubviews()
        setupConstraints()
        setupViews()
    }
    
    private func addSubviews() {
        addSubview(horizontalStack)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            horizontalStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    private func setupViews() {
        backgroundColor = Colors.primaryBackgroundColor
    }
    
    func createSubviews(titleText: String, valueText: String) {
        let verticalStack: UIStackView = {
            let stack = UIStackView()
            stack.spacing = 4
            stack.axis = .vertical
            stack.distribution = .equalSpacing
            return stack
        }()
        
        let value = UILabel()
        value.text = valueText
        value.textColor = Colors.primaryTextOnSurfaceColor
        value.font = .systemFont(ofSize: 20, weight: .semibold)
        
        let label = UILabel()
        label.text = titleText
        label.textColor = Colors.primaryTextOnSurfaceColor
        label.font = .systemFont(ofSize: 13, weight: .regular)
        
        [label, value].forEach {
            verticalStack.addArrangedSubview($0)
        }
        
        horizontalStack.addArrangedSubview(verticalStack)
    }
}
