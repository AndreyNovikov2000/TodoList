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
       
        setuCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setuCollectionView() {
        delegate = self
        dataSource = self
        register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseId)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        contentInset = UIEdgeInsets(top: 0, left: Constants.listCollectionViewInsets.left, bottom: 0, right: Constants.listCollectionViewInsets.right)
    }
}


// MARK: - UICollectionViewDataSource
extension ListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.reuseId, for: indexPath) as! ListCell
        
        cell.set(text: "123")
    
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ListCollectionView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.listCollectionViewContentSize.width, height: Constants.listCollectionViewContentSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.listCollectionViewMinimumLineSpacing
    }
}
