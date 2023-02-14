//
//  FilmDetailController.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 21.01.2023.
//

import UIKit
import SDWebImage

protocol FilmDetailControllerProtocol: AnyObject {
    func configure(with item: DetailsFilmResponse)
    func errorAlert(error: ErrorModel)
    func setupLikeButton(isLiked: Bool)
    func addSimilarFilms(items: [Item])
}

final class FilmDetailController: UIViewController {
    
    // MARK: - Public Properties
    var presenter: FilmDetailPresenterProtocol?
    
    // MARK: - Private Properties
    private let scrollView = UIScrollView()
    private let topView = UIView()
    private let bottomView = UIView()
    private let imageView = UIImageView()
    private let likeButton = UIButton()
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let backImageView = UIImageView()
    private let detailsView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
    private let similarFilmsView = SimilarFilmsView()
   
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.loadData()
    }
    
    // MARK: - Private Methods
    private func setup() {
        addSubviews()
        setupConstraints()
        setupViews()
        setupButtons()
    }
    
    private func addSubviews(){
        [scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [topView, bottomView, detailsView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        [detailsView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bottomView.addSubview($0)
        }
        [backImageView, blurEffectView, imageView, likeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            topView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height / 3 * 2),
            
            blurEffectView.topAnchor.constraint(equalTo: topView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            backImageView.topAnchor.constraint(equalTo: topView.topAnchor),
            backImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            backImageView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            backImageView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 24),
            imageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 48),
            imageView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -48),
            imageView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -40),
            
            likeButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            likeButton.heightAnchor.constraint(equalToConstant: 32),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor),

            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: -16),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            detailsView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            detailsView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            detailsView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
        ])
    }
    
    private func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = Colors.primaryBackgroundColor
        detailsView.backgroundColor = Colors.primaryBackgroundColor
        bottomView.backgroundColor = Colors.primaryBackgroundColor
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        
        backImageView.contentMode = .scaleAspectFill
        backImageView.clipsToBounds = true
        
        bottomView.layer.cornerRadius = 16
        bottomView.clipsToBounds = true
    }
    
    private func setImage(path: String) {
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
        imageView.sd_setImage(with: url)
        backImageView.sd_setImage(with: url)
    }
    
    private func addArrangedSubviews(item: DetailsFilmResponse) {
        
        let label = UILabel()
        label.text = item.title
        label.textColor = Colors.primaryTextOnSurfaceColor
        label.font = .systemFont(ofSize: 37)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        detailsView.addArrangedSubview(wrapLabel(labelView: label))
        
        let yearLabel = UILabel()
        yearLabel.text = item.releaseDate
        yearLabel.textColor = Colors.primaryTextOnSurfaceColor
        yearLabel.font = .systemFont(ofSize: 17)
        detailsView.addArrangedSubview(wrapLabel(labelView: yearLabel))
        
        let description = UILabel()
        description.text = item.overview
        description.textColor = Colors.primaryTextOnSurfaceColor
        description.numberOfLines = 0
        description.lineBreakMode = .byWordWrapping
        description.font = .systemFont(ofSize: 20)
        detailsView.addArrangedSubview(wrapLabel(labelView: description))
        
        detailsView.setCustomSpacing(16, after: yearLabel)
        
        configureSimilarView()
    }
    
    private func configureSimilarView() {
        similarFilmsView.getNext = { [weak self] in
            self?.presenter?.getSimilarFilms()
        }
        similarFilmsView.showDetails = { [weak self] in
            self?.presenter?.showDetails(item: $0)
        }
        presenter?.getSimilarFilms()
        detailsView.addArrangedSubview(similarFilmsView)
    }
    
    private func wrapLabel(labelView: UILabel) -> UIView {
        let textView = UIView()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        textView.addSubview(labelView)
        labelView.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 16).isActive = true
        labelView.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -16).isActive = true
        labelView.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        labelView.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        return textView
    }
    
    private func setupButtons() {
        likeButton.addTarget(self, action: #selector(likeDidTapped), for: .touchUpInside)
        presenter?.setupLikeButton()
    }
    
    // MARK: - Public Methods
    @objc
    func likeDidTapped() {
        presenter?.likeDidTapped()
    }
}

// MARK: - Protocols
extension FilmDetailController: FilmDetailControllerProtocol {
    func configure(with item: DetailsFilmResponse) {
        if let poster = item.posterPath {
            setImage(path: poster)
        }
        addArrangedSubviews(item: item)
    }
    
    func addSimilarFilms(items: [Item]) {
        similarFilmsView.loadData(items: items)
    }
    
    func errorAlert(error: ErrorModel) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.presenter?.popOut()
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
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
