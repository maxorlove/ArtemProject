//
//  GridCollectionViewCell.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 07.01.2023.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
   
    let image = UIImageView()
    let label = UILabel()
    
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
        setupView()
    }
    
    func addSubviews() {
        [image, label].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func setupView() {
        backgroundColor = .gray
    }
    
    func congigure(_with item: Item) {
        label.text = item.title
    }
}
