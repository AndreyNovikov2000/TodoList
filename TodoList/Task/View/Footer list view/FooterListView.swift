//
//  FooterListView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class FooterListView: UIView {
    
    // MARK: - UI
    let footerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.7443082929, green: 0.7490350604, blue: 0.7576260567, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let listCollectionView: ListCollectionView = {
        let collectionView = ListCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraintsForFooterElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PublicProperties
    func setFooterText(text: String) {
        footerLabel.text = text
    }
    
    // MARK: - Constraints
    private func setupConstraintsForFooterElements() {
        addSubview(footerLabel)
        addSubview(listCollectionView)
        
        footerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        footerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60).isActive = true
        
        listCollectionView.topAnchor.constraint(equalTo: footerLabel.bottomAnchor, constant: 15).isActive = true
        listCollectionView.heightAnchor.constraint(equalToConstant: Constants.listCollectionViewContentSize.height).isActive = true
        listCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        listCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}



