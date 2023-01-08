//
//  ViewController.swift
//  ArtemProject
//
//  Created by Orlov Maxim on 27.12.2022.
//

import UIKit

class FilmsGridViewController: UIViewController {

    private let filmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    
    private var dataSourse: [Item] = []
    
    private let networkClient = NetworkServiceImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadData(for: currentPage)
    }
    
    private func setup() {
        addSubviews()
        setupConstraints()
        setupColectionViews()
    }
    
    private func addSubviews() {
        [filmsCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filmsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filmsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            filmsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filmsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupColectionViews() {
        filmsCollectionView.delegate = self
        filmsCollectionView.dataSource = self
        filmsCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: Constants.gridCellReuseId)
    }

    private func loadData(for page: Int) {
        networkClient.getPopularMovies(page: page) { [weak self] result in
            switch result {
                case .success(let response):
                DispatchQueue.main.async {
                    self?.dataSourse.append(contentsOf: response.results)
                    self?.totalPages = response.totalPages
                    self?.filmsCollectionView.reloadData()
                }
                case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                }))
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
                break
            }
        }
    }
}
   
extension FilmsGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSourse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filmsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.gridCellReuseId, for: indexPath) as! GridCollectionViewCell
        let model = dataSourse[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension FilmsGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.itemSize, height: Constants.itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSourse.count - 3 == indexPath.row, currentPage < totalPages {
            currentPage += 1
            loadData(for: currentPage)
        }
    }
}

private enum Constants {
    static let gridCellReuseId = "GridCollectionViewCellIdentifier"
    static let numberOfItemsInRow: CGFloat = 3
    static let itemSize: CGFloat = (UIScreen.main.bounds.width / numberOfItemsInRow) - spacing
    static let spacing: CGFloat = 2
}
