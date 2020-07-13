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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseId, for: indexPath) as? TaskCell else { return UITableViewCell() }
        let task = tasks2d[indexPath.section][indexPath.row]
        
        cell.set(task: task)
        cell.myDelegate = self
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, complition) in
            print(indexPath)
            complition(true)
        }
        
        deleteAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            
            let todayHeaderView = HeaderView()
            todayHeaderView.headerLabel.text = "Today"
            todayHeaderView.headerLabel.textColor = UIColor(red: 0, green: 0.4384983182, blue: 0.839425087, alpha: 1)
            return todayHeaderView
            
        case 1:
            
            let tomorrowHeaderView = HeaderView()
            tomorrowHeaderView.headerLabel.text = "Tomorrow"
            tomorrowHeaderView.headerLabel.textColor = UIColor(red: 0.05028516799, green: 0.3882673085, blue: 0.6095688939, alpha: 1)
            return tomorrowHeaderView
            
        case 2:
            
            let laterHeaderView = HeaderView()
            laterHeaderView.headerLabel.text = "Later"
            laterHeaderView.headerLabel.textColor = UIColor(red: 0.1410068274, green: 0.1647966504, blue: 0.1949454248, alpha: 1)
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
