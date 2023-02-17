//
//  FilmDetailViews.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 16.02.2023.
//

import UIKit

final class RatingBlockView: UIView {
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        addSubview()
        setupConstraints()
        setupViews()
    }
    
    private func addSubview() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupViews() {
        backgroundColor = Colors.primaryBackgroundColor
    }
    
    func createSubviews(titleText: String, valueText: String, withImage: Bool) {
        let view = RatingBlockDetailView()
        view.createSubviews(titleText: titleText, valueText: valueText, withImage: withImage)
        stack.addArrangedSubview(view)
    }
}
