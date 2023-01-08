//
//  GridCollectionViewCell.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 07.01.2023.
//

import UIKit
import SDWebImage

class GridCollectionViewCell: UICollectionViewCell {
   
    private let image = UIImageView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        addSubviews()
        setupConstraints()
        setupView()
    }
    
    private func addSubviews() {
        [image, label].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
        ])
    }
    
    private func setupView() {
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
    }
    
    func configure(with item: Item) {
        label.text = item.title
        guard let poster = item.posterPath else {return}
        setImage(path: poster)
    }
    
    private func setImage(path: String) {
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
        image.sd_setImage(with: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        image.sd_cancelCurrentImageLoad()
        image.image = nil
    }
}
