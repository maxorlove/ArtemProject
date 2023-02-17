//
//  SimilarFilmsView.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 09.02.2023.
//

import UIKit

final class SimilarFilmsView: UIView {
    var getNext: (() -> (Void))?
    var showDetails: ((DetailDataStruct) -> (Void))?
    private var dataSourse: [Item] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func loadData(items: [Item]) {
        dataSourse.append(contentsOf: items)
        collectionView.reloadData()
    }
    
    private func setup() {
        addSubviews()
        setupConstraints()
        setupColectionViews()
    }
    
    private func addSubviews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func setupColectionViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FilmDetailCellView.self, forCellWithReuseIdentifier: Constants.reuseIdentifier)
    }
    
    private func updateCell(index: Int) {
        if let index = searchIndexForId(id: index) {
            collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    private func searchIndexForId(id: Int) -> Int? {
        if let index = dataSourse.firstIndex(where: {$0.id == id}) {
            return index
        } else {
            return nil
        }
    }
}

extension SimilarFilmsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSourse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSourse[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! FilmDetailCellView
        cell.configure(with: model)
        cell.likeDidTappedCallback = { [weak self] id in
            collectionView.reloadItems(at: [indexPath])
        }
        return cell
    }
}

extension SimilarFilmsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height * 2 / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.space
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSourse.count - 1 == indexPath.row {
            getNext?()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let id = dataSourse[index].id
        var dataStruct = DetailDataStruct.init(id: id)
        dataStruct.callBack = { [weak self] id in
            self?.updateCell(index: id)
        }
        showDetails?(dataStruct)
    }
}

private enum Constants {
    static let reuseIdentifier = "FilmDetailCellView"
    static let space = 3.0
}
