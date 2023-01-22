//
//  GridSingleViewCell.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 19.01.2023.
//

import UIKit
import SDWebImage

class GridSingleViewCell: UICollectionViewCell {
    
    private let image = UIImageView()
    private let label = UILabel()
    private let yearLabel = UILabel()
    private let ratingView = UIView()
    private let ratingLabel = UILabel()
    private let ratingImg = UIImageView()
    
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
        [ratingImg, ratingLabel].forEach {
            ratingView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [image, label, yearLabel, ratingView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            image.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3),
            
            yearLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 24),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            label.bottomAnchor.constraint(equalTo: yearLabel.topAnchor),
            
            ratingView.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -4),
            ratingView.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -4),
            ratingView.widthAnchor.constraint(equalToConstant: 66),
            ratingView.heightAnchor.constraint(equalToConstant: 32),
            
            ratingImg.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            ratingImg.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 6),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: -6),
        ])
    }
    
    private func setupView() {
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 16
        
        label.font = .systemFont(ofSize: 27)
        label.textColor = Colors.primaryTextOnBackgroundColor
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.clipsToBounds = true

        yearLabel.font = .systemFont(ofSize: 17)
        yearLabel.textColor = Colors.secondaryTextOnSurfaceColor
        yearLabel.textAlignment = .left
        
        ratingView.backgroundColor = Colors.secondarySurfaceColor
        ratingView.layer.cornerRadius = 13
        
        ratingImg.image = UIImage(named: "star")
        
        ratingLabel.font = .systemFont(ofSize: 15)
        ratingLabel.textColor = Colors.accentTextColor
    }
    
    func configure(with item: Item) {
        label.text = item.title
        yearLabel.text = item.releaseDate
        ratingLabel.text = "\(item.voteAverage)"
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
        yearLabel.text = nil
        image.sd_cancelCurrentImageLoad()
        image.image = nil
        ratingLabel.text = nil
    }
}
