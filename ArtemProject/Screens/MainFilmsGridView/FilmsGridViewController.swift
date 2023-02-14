//
//  ViewController.swift
//  ArtemProject
//
//  Created by Orlov Maxim on 27.12.2022.
//

import UIKit

protocol FilmsGridViewControllerProtocol: AnyObject {
    func reloadDataSourse(response: AllFilmsResponse)
    func errorAlert(error: ErrorModel)
    func clearDataSource(sortStyle: SortEnum)
    func updateCell(index: Int)
}

final class FilmsGridViewController: UIViewController {
    
    // MARK: - Public Properties
    var presenter: FilmsGridPresenterProtocol?
    
    // MARK: - Private Properties
    private let sortView = SortActionView()
    private let filmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    private var dataSourse: [Item] = []
    private var gridType: GridType = .double
    private var itemSize: CGFloat = 0.0
    
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
            filmsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filmsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            filmsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.border),
            filmsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.border),
            
            sortView.bottomAnchor.constraint(equalTo: filmsCollectionView.bottomAnchor, constant: -6),
            sortView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 104),
            sortView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -104),
            sortView.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    private func setupViews() {
        view.backgroundColor = Colors.primaryBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        itemSize = getItemSize(gridType: gridType)
        
        sortView.gridSizeChangeAction = { [weak self] in
            self?.gridSizeChangeAction()
        }
        sortView.sortButtonChoseAction = { [weak self] in
            self?.sortButtonAction()
        }
        
        self.navigationItem.title = "Movies"
        sortView.changeImgButton(gridType: gridType)
    }
    
    private func setupColectionViews() {
        filmsCollectionView.delegate = self
        filmsCollectionView.dataSource = self
        filmsCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: Constants.gridCellReuseId)
        filmsCollectionView.register(GridSingleViewCell.self, forCellWithReuseIdentifier: Constants.singleCellReuseId)
    }
    
    private func sortButtonAction() {
        let alert = UIAlertController(title: "Sort movies:", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Top rated", style: UIAlertAction.Style.default, handler: { action in
            self.presenter?.didSortButtonPressed(sortStyle: .topRated)
            self.sortView.changeSortLabel(sortStyle: .topRated)
        }))
        alert.addAction(UIAlertAction(title: "Popular", style: UIAlertAction.Style.default, handler: { action in
            self.presenter?.didSortButtonPressed(sortStyle: .popular)
            self.sortView.changeSortLabel(sortStyle: .popular)
        }))
        let cancelActoin = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelActoin)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func gridSizeChangeAction() {
        updateGridType()
        filmsCollectionView.reloadData()
        sortView.changeImgButton(gridType: gridType)
    }
    
    private func updateGridType() {
        switch gridType {
            case .single:
                gridType = .double
            case .double:
                gridType = .single
        }
        itemSize = getItemSize(gridType: gridType)
    }
    
    private func getItemSize(gridType: GridType) -> CGFloat {
        return (UIScreen.main.bounds.width / CGFloat(gridType.rawValue)) - Constants.spacing - Constants.border
    }
    
    private func showDetails(item: Item) {
        presenter?.showDetails(item: item)
    }
    
    private func searchIndexForId(id: Int) -> Int? {
        if let index = dataSourse.firstIndex(where: {$0.id == id}) {
            return index
        } else {
            return nil
        }
    }
}

// MARK: - Datasourse/Prorocols
extension FilmsGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSourse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSourse[indexPath.row]
        
        switch gridType {
        case .single:
            let cell = filmsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.singleCellReuseId, for: indexPath) as! GridSingleViewCell
            cell.configure(with: model)
            cell.likeDidTappedCallback = { [weak self] id in
                self?.presenter?.likeDidTapped(id: id)
            }
            return cell
        case .double:
            let cell = filmsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.gridCellReuseId, for: indexPath) as! GridCollectionViewCell
            cell.configure(with: model)
            cell.likeDidTappedCallback = { [weak self] id in
                self?.presenter?.likeDidTapped(id: id)
            }
            return cell
        }
    }
}

extension FilmsGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch gridType {
        case .single:
            return CGSize(width: itemSize, height: itemSize / 2)
        case .double:
            return CGSize(width: itemSize, height: itemSize * 3 / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let next = presenter?.getNext() else { return }
        if dataSourse.count - Int(gridType.rawValue) == indexPath.row, next {
            presenter?.loadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let item = dataSourse[index]
        showDetails(item: item)
    }
}

extension FilmsGridViewController: FilmsGridViewControllerProtocol {
    
    func clearDataSource(sortStyle: SortEnum) {
        self.sortView.changeSortLabel(sortStyle: sortStyle)
        self.dataSourse.removeAll()
    }
    
    
    func reloadDataSourse(response: AllFilmsResponse) {
        DispatchQueue.main.async {
            self.dataSourse.append(contentsOf: response.results)
            self.filmsCollectionView.reloadData()
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
    
    func updateCell(index: Int) {
        if let index = searchIndexForId(id: index) {
            filmsCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
}

private enum Constants {
    static let gridCellReuseId = "GridCollectionViewCellIdentifier"
    static let singleCellReuseId = "SingleCellReuseId"
    static let spacing: CGFloat = 3
    static let border: CGFloat = 3
}
