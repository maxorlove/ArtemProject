//
//  SotrView.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 18.01.2023.
//

import UIKit

class SortView: UIView {
    
    var gridSizeChangeAction: (() -> Void)?
    var sortButtonChoseAction: ((SortEnum) -> Void)?
    
    private let sortButton = UIButton()
    private let gridChangeButton = UIButton()
    
    private let verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        addSubviews()
        setupConstraints()
        setupViews()
        setupButtons()
    }
    
    private func addSubviews() {
        [sortButton, gridChangeButton, verticalStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sortButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            sortButton.heightAnchor.constraint(equalTo: gridChangeButton.heightAnchor),
            
            gridChangeButton.leadingAnchor.constraint(equalTo: sortButton.trailingAnchor, constant: 6),
            gridChangeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            gridChangeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridChangeButton.heightAnchor.constraint(equalTo: gridChangeButton.widthAnchor),
            
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: sortButton.topAnchor, constant: -3)
        ])
    }
    
    private func setupViews() {
        backgroundColor = .gray.withAlphaComponent(0.1)
    }
    
    private func setupButtons() {
        sortButton.backgroundColor = Colors.primarySurfaceColor
        sortButton.setTitle("Sorting", for: .normal)
        sortButton.addTarget(self, action: #selector(activateStackView), for: .touchUpInside)
        
        gridChangeButton.backgroundColor = Colors.primarySurfaceColor
        gridChangeButton.setTitle("X", for: .normal)
        gridChangeButton.addTarget(self, action: #selector(gridSizeChangeActionButton), for: .touchUpInside)
    }
    
    @objc
    private func activateStackView() {
        if verticalStackView.arrangedSubviews.count != 0 {
            deactivateStackView()
        } else {
            var tag = 0
            SortEnum.allCases.forEach {
                addArrangedSubview(sortStyle: $0, tag: tag)
                tag += 1
            }
        }
    }
    
    private func addArrangedSubview(sortStyle: SortEnum, tag: Int) {
        let button = UIButton()
        button.backgroundColor = Colors.primarySurfaceColor
        button.setTitle(sortStyle.rawValue, for: .normal)
        button.tag = tag
        button.addTarget(self, action: #selector(choseSortStyle), for: .touchUpInside)
        verticalStackView.addArrangedSubview(button)
    }
    
    private func deactivateStackView() {
        verticalStackView.arrangedSubviews.forEach {
            verticalStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    @objc
    private func gridSizeChangeActionButton() {
        gridSizeChangeAction?()
    }
    
    @objc
    private func choseSortStyle(sender: UIButton) {
        deactivateStackView()
        sortButtonChoseAction?(SortEnum.allCases[sender.tag])
    }
}
