//
//  ListCollectionView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/18/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ListCollectionView: UICollectionView {
    
    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: layout)
       
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Private methods
    private func setupCollectionView() {
        register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseId)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        dragInteractionEnabled = true
        contentInset = UIEdgeInsets(top: 0, left: Constants.collectionViewInsets.left, bottom: 0, right: Constants.collectionViewInsets.right)
    }
}


