//
//  RatingBlockDetailView.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 16.02.2023.
//

import UIKit

class RatingBlockDetailView: UIView {
    
    //MARK: - private properties
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        return stack
    }()
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        stack.spacing = 14
        return stack
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    //MARK: - private func
    private func setup() {
        addSubviews()
        setupConstrainst()
        setupView()
    }
    
    private func addSubviews() {
        [horizontalStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setupConstrainst() {
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            horizontalStack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            horizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
        ])
    }
    
    private func setupView() {
        backgroundColor = Colors.secondaryBackgroundColor
        layer.cornerRadius = 24
    }
    
    func createSubviews(titleText: String, valueText: String, withImage: Bool) {
        if withImage {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "blackStar")
            imageView.contentMode = .scaleAspectFit
            horizontalStack.addArrangedSubview(imageView)
        }
        
        let value = UILabel()
        value.text = valueText
        value.textColor = Colors.primaryTextOnSurfaceColor
        value.font = .systemFont(ofSize: 20, weight: .semibold)
        
        let label = UILabel()
        label.text = titleText
        label.textColor = Colors.primaryTextOnSurfaceColor
        label.font = .systemFont(ofSize: 13, weight: .regular)
        
        [value, label].forEach {
            verticalStack.addArrangedSubview($0)
        }
        
        horizontalStack.addArrangedSubview(verticalStack)
    }
}
