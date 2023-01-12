//
//  ViewController.swift
//  ArtemProject
//
//  Created by Orlov Maxim on 27.12.2022.
//

import UIKit

class FilmsGridViewController: UIViewController {
    
    private var currentSortStyle: SortEnum = .def
    
    private let sortView: UIView = {
        let sortView = UIView()
        let label = UILabel()
        let marker = UIButton()
        let sortButton = UIButton()
        [label, marker, sortButton].forEach {
            sortView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: sortView.leadingAnchor),
            label.topAnchor.constraint(equalTo: sortView.topAnchor),
            
            marker.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            marker.topAnchor.constraint(equalTo: sortView.topAnchor),
            
            sortButton.leadingAnchor.constraint(equalTo: marker.trailingAnchor),
            sortButton.topAnchor.constraint(equalTo: sortView.topAnchor),
            sortButton.trailingAnchor.constraint(equalTo: sortView.trailingAnchor),
        ])
        label.text = "Sorted by:"
        label.textColor = .white
        marker.setImage(UIImage(systemName: "paperplane"), for: .normal)
        sortButton.setTitle("Default", for: .normal)
        sortButton.setTitleColor(.white, for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonAction), for: .touchDown)
        return sortView
    }()
    
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
        loadData(for: currentPage, sortStyle: currentSortStyle)
    }
    
    private func setup() {
        view.backgroundColor = .black
        addSubviews()
        setupConstraints()
        setupColectionViews()
    }
    
    private func addSubviews() {
        [filmsCollectionView, sortView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sortView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sortView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/20),
            
            filmsCollectionView.topAnchor.constraint(equalTo: sortView.bottomAnchor),
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
    
    private func loadData(for page: Int, sortStyle: SortEnum) {
        switch sortStyle {
        case .def:
            networkClient.getPopularMovies(page: page) { [weak self] result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self?.dataSourse.append(contentsOf: response.results)
                        self?.totalPages = response.totalPages
                        self?.filmsCollectionView.reloadData()
                    }
                case .failure(let error):
                    self?.errorAlert(error: error)
                }
            }
        case .topRated:
            networkClient.getTopRated(page: page) { [weak self] result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self?.dataSourse.append(contentsOf: response.results)
                        self?.totalPages = response.totalPages
                        self?.filmsCollectionView.reloadData()
                    }
                case .failure(let error):
                    self?.errorAlert(error: error)
                }
            }
        case .popular:
            networkClient.getNowPlaying(page: page) { [weak self] result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self?.dataSourse.append(contentsOf: response.results)
                        self?.totalPages = response.totalPages
                        self?.filmsCollectionView.reloadData()
                    }
                case .failure(let error):
                    self?.errorAlert(error: error)
                }
            }
        }
    }
    
    func errorAlert(error: ErrorModel) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
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
            loadData(for: currentPage, sortStyle: currentSortStyle)
        }
    }
    
    @objc
    func sortButtonAction() {
        let alert = UIAlertController(title: "Sort movies:", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Top rated", style: UIAlertAction.Style.default, handler: { action in
            self.currentSortStyle = .topRated
            self.dataSourse.removeAll()
            self.loadData(for: 1, sortStyle: .topRated)
        }))
        alert.addAction(UIAlertAction(title: "Popular", style: UIAlertAction.Style.default, handler: { action in
            self.currentSortStyle = .popular
            self.dataSourse.removeAll()
            self.loadData(for: 1, sortStyle: .popular)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

private enum Constants {
    static let gridCellReuseId = "GridCollectionViewCellIdentifier"
    static let numberOfItemsInRow: CGFloat = 3
    static let itemSize: CGFloat = (UIScreen.main.bounds.width / numberOfItemsInRow) - spacing
    static let spacing: CGFloat = 2
}
