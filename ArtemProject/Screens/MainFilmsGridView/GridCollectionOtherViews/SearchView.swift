//
//  SortBar.swift
//  ArtemProject
//
//  Created by Artem Vavilov on 14.02.2023.
//

import UIKit

final class SearchView: UIView {
    
    //  MARK: - public parameters
    var action: ((String)->(Void))?
    
    //  MARK: - private parameters
    private let text = UITextField()
    private let searchButton = UIButton()
    
    //  MARK: - init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    //  MARK: - private functions
    private func setup() {
        [text, searchButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            text.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            text.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            text.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            
            searchButton.topAnchor.constraint(equalTo: topAnchor),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            searchButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor)
        ])
        
        searchButton.addTarget(self, action: #selector(searchDidTapped), for: .touchUpInside)
        
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        text.delegate = self
        text.placeholder = "Search"
        text.backgroundColor = Colors.primarySurfaceColor
        text.returnKeyType = .search
    }
    
    @objc
    private func searchDidTapped() {
        if let text = text.text, !text.isEmpty {
            action?(text)
        }
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        searchDidTapped()
        return false
    }
}
