//
//  CreateTaskViewController+Data.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


// MARK: - UITableViewDataSource
extension CreateTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task?.subTasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubTaskCell.reuseId, for: indexPath) as! SubTaskCell
        let subTask = task?.subTasks?[indexPath.row] as? SubTask
        
        cell.set(subTask: subTask)
        cell.myDelegate = self
        return cell
    }
}


// MARK: - UITableViewDelegate
extension CreateTaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let moveSubTask = task?.subTasks?[sourceIndexPath.row] else { return }
        let subTasks = task?.subTasks?.mutableCopy() as? NSMutableOrderedSet
        
        subTasks?.removeObject(at: sourceIndexPath.row)
        subTasks?.insert(moveSubTask, at: destinationIndexPath.row)
        
        task?.subTasks = subTasks
    }
}
