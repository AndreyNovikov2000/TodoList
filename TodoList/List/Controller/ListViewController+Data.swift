//
//  ListViewController+Data.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = list?.detailLists?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reuseId, for: indexPath) as! TaskListCell
        
        if let detailList = list?.detailLists?[indexPath.row] as? DetailList {
            cell.set(with: detailList, backgroundColor: defaulListtColor)
            cell.myDelegate = self
        }
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteContextualAction(with: indexPath)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailList = list?.detailLists?[indexPath.row] as? DetailList
        NotificationCenter.default.removeObserver(self)
        setupSubListViewController(with: detailList)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mutableList = list?.detailLists?.mutableCopy() as? NSMutableOrderedSet
        guard let deletedObject = mutableList?[sourceIndexPath.row] else { return }
        
        mutableList?.remove(deletedObject)
        mutableList?.insert(deletedObject, at: destinationIndexPath.row)
        
        list?.detailLists = mutableList
        
        storageManager.save()
    }
}
