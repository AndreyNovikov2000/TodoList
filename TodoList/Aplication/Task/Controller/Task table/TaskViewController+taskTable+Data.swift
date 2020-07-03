//
//  TaskViewController+taskTable+Data.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


// MARK: - UITableViewDataSource
extension TaskViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks2d.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks2d[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseId, for: indexPath) as! TaskCell
        let task = tasks2d[indexPath.section][indexPath.row]
        
        cell.set(task: task)
        cell.myDelegate = self
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        
        return UISwipeActionsConfiguration()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            
            let todayHeaderView = HeaderView()
            todayHeaderView.headerLabel.text = "Today"
            return todayHeaderView
            
        case 1:
            
            let tomorrowHeaderView = HeaderView()
            tomorrowHeaderView.headerLabel.text = "Tomorrow"
            return tomorrowHeaderView
            
        case 2:
            
            let laterHeaderView = HeaderView()
            laterHeaderView.headerLabel.text = "Later"
            return laterHeaderView
            
        default:
            return UIView(frame: .zero)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task =  tasks2d[indexPath.section][indexPath.row]
        presentSubTaskColtroller(with: task)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        
        let deletedObject = tasks2d[sourceIndexPath.section][sourceIndexPath.row]
        tasks2d[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        tasks2d[destinationIndexPath.section].insert(deletedObject, at: destinationIndexPath.row)
        
        model.moveRow(with: tasks2d, from: sourceIndexPath, to: destinationIndexPath)
    }
}
