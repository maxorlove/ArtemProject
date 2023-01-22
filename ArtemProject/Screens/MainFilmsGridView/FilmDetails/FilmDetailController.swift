//
//  FilmDetailController.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 21.01.2023.
//

import UIKit
import SDWebImage

class FilmDetailController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let topView = UIView()
    private let detailsView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        addSubviews()
        setupConstraints()
        setupViews()
    }
    
    private func addSubviews(){
        [scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [topView, detailsView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        [imageView].forEach {
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
            
            imageView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 24),
            imageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 48),
            imageView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -48),
            imageView.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -40),
//            imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
//            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height / 3 * 2),
            

            detailsView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: -16),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = Colors.primaryBackgroundColor
        detailsView.backgroundColor = Colors.primaryBackgroundColor
        topView.backgroundColor = Colors.secondarySurfaceColor
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        
        detailsView.layer.cornerRadius = 16
        detailsView.clipsToBounds = true
    }
    
    func configure(with item: DetailsFilmResponse) {
        guard let poster = item.posterPath else {return}
        setImage(path: poster)
        addArrangedSubviews(item: item)
    }
    
    private func setImage(path: String) {
        let url = URL(string: "https://image.tmdb.org/t/p/original/\(path)")
        imageView.sd_setImage(with: url)
    }
    
    private func addArrangedSubviews(item: DetailsFilmResponse) {
        
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 16))
        detailsView.addArrangedSubview(spacer)
        
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
}
