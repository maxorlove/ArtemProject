//
//  SotrView.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 18.01.2023.
//

import UIKit

class SortActionView: UIView {
    
    var gridSizeChangeAction: (() -> Void)?
    var sortButtonChoseAction: (() -> Void)?
    
    private let sortButton = UIButton()
    private let gridChangeButton = UIButton()
    
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
        [sortButton, gridChangeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sortButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            sortButton.heightAnchor.constraint(equalTo: heightAnchor),
            
            gridChangeButton.leadingAnchor.constraint(equalTo: sortButton.trailingAnchor, constant: 8),
            gridChangeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            gridChangeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridChangeButton.heightAnchor.constraint(equalTo: sortButton.heightAnchor),
            gridChangeButton.widthAnchor.constraint(equalToConstant: 56),

        ])
    }
    
    private func setupViews() {
        
    }
    
    private func setupButtons() {
        sortButton.backgroundColor = Colors.primarySurfaceColor
        sortButton.setTitle("Sorting", for: .normal)
        sortButton.setTitleColor(Colors.primaryTextOnSurfaceColor, for: .normal)
        sortButton.layer.cornerRadius = 20
        sortButton.clipsToBounds = false
        sortButton.addTarget(self, action: #selector(sortButtonAction), for: .touchUpInside)
        
        sortButton.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        sortButton.layer.shadowOffset = CGSize(width: 12, height: 8)
        sortButton.layer.shadowOpacity = 0.8
        sortButton.layer.shadowRadius = 10
        
        gridChangeButton.backgroundColor = Colors.primarySurfaceColor
        gridChangeButton.setImage(UIImage(named: "gridSizeChanger"), for: .normal)
        gridChangeButton.layer.cornerRadius = 20
        gridChangeButton.clipsToBounds = false
        gridChangeButton.addTarget(self, action: #selector(gridSizeChangeButtonAction), for: .touchUpInside)
        
        gridChangeButton.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        gridChangeButton.layer.shadowOffset = CGSize(width: 12, height: 8)
        gridChangeButton.layer.shadowOpacity = 0.8
        gridChangeButton.layer.shadowRadius = 10
    }
    
    func changeSortLabel(sortStyle: SortEnum) {
        sortButton.setTitle(sortStyle.rawValue, for: .normal)
    }
    
    func changeImgButton(gridType: GridType) {
        switch gridType {
        case .single:
            gridChangeButton.setImage(UIImage(named: "gridSizeChanger"), for: .normal)
        case .double:
            gridChangeButton.setImage(UIImage(named: "singleGridChanger"), for: .normal)
        }
    }
    
    @objc
    private func gridSizeChangeButtonAction() {
        gridSizeChangeAction?()
    }
    
    @objc
    private func sortButtonAction() {
        sortButtonChoseAction?()
    }
}
