//
//  TaskViewController+footerList+Data.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


// MARK: - UICollectionViewDataSource
extension TaskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.reuseId, for: indexPath) as! ListCell
        let list = lists[indexPath.row]
        
        cell.set(list: list)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TaskViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedList = lists[indexPath.row]
        presentListViewController(with: selectedList)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}
