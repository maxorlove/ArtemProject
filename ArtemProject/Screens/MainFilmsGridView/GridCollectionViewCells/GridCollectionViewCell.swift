//
//  GridCollectionViewCell.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 07.01.2023.
//

import UIKit
import SDWebImage

final class GridCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    var likeDidTappedCallback: ((Int) -> (Void))?
    
    // MARK: - Private Properties
    private let image = UIImageView()
    private let labelView = UIView()
    private let labelText = UILabel()
    private let ratingView = UIView()
    private let ratingLabel = UILabel()
    private let ratingImg = UIImageView()
    private let likeButton = UIButton()
    private var id: Int?
    
    // MARK: - Init/Deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        labelText.text = nil
        ratingLabel.text = nil
        image.sd_cancelCurrentImageLoad()
        image.image = nil
    }
    
    // MARK: - Private Methods
    private func setup() {
        addSubviews()
        setupConstraints()
        setupView()
        setupButtons()
    }
    
    private func addSubviews() {
        labelView.addSubview(labelText)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        
        [ratingImg, ratingLabel].forEach {
            ratingView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [image, labelView, ratingView, likeButton].forEach {
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
            
            labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            labelView.heightAnchor.constraint(equalToConstant: contentView.frame.height / 4.5),
            
            labelText.centerXAnchor.constraint(equalTo: labelView.centerXAnchor),
            labelView.centerYAnchor.constraint(equalTo: labelView.centerYAnchor),
            labelText.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 12),
            labelText.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -12),
            labelText.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 4),
            labelText.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -4),
            
            ratingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            ratingView.widthAnchor.constraint(equalToConstant: contentView.frame.width / 3),
            ratingView.heightAnchor.constraint(equalToConstant: 32),
            
            ratingImg.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            ratingImg.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 6),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: -6),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            likeButton.widthAnchor.constraint(equalToConstant: 32),
            likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor),
        ])
    }
    
    private func setupView() {
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 16
        
        labelView.backgroundColor = Colors.secondarySurfaceColor
        labelView.layer.cornerRadius = 13
        
        labelText.font = .systemFont(ofSize: 20)
        labelText.textColor = Colors.accentTextColor
        labelText.textAlignment = .center
        labelText.lineBreakMode = .byWordWrapping
        labelText.numberOfLines = 0
        labelText.minimumScaleFactor = 0.5
        labelText.adjustsFontSizeToFitWidth = true

        ratingView.backgroundColor = Colors.secondarySurfaceColor
        ratingView.layer.cornerRadius = 13
        
        ratingImg.image = UIImage(named: "star")
        
        ratingLabel.font = .systemFont(ofSize: 15)
        ratingLabel.textColor = Colors.accentTextColor
    }
    
    private func setupButtons() {
        likeButton.addTarget(self, action: #selector(likeDidTapped), for: .touchUpInside)
    }
    
    private func setImage(path: String) {
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
        image.sd_setImage(with: url)
    }
    
    @objc
    private func likeDidTapped() {
        guard let id = id else { return }
        likeDidTappedCallback?(id)
        setupLikeButton(isLiked: LikesManager.checkLikedFilm(id: id))
    }
    
    //MARK: - Public Methods
    
    func configure(with item: Item) {
        id = item.id
        labelText.text = item.title
        ratingLabel.text = "\(item.voteAverage)"
        guard let poster = item.posterPath else {return}
        setImage(path: poster)
        setupLikeButton(isLiked: LikesManager.checkLikedFilm(id: item.id))
    }
    
    func setupLikeButton(isLiked: Bool) {
        let imageConfig = UIImage.SymbolConfiguration(scale: .large)
        if isLiked {
            likeButton.tintColor = .red
            likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: imageConfig), for: .normal)
        } else {
            likeButton.tintColor = .systemGray
            likeButton.setImage(UIImage(systemName: "heart", withConfiguration: imageConfig), for: .normal)
        }
    }
}
