//
//  TaskViewController+taskTable+Cell.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

// MARK: - TaskCellDelegate
extension TaskViewController: TaskCellDelegate {
    func taskCellDidComplite(taskCell: TaskCell) {
        guard let indexPath = taskTableView.indexPath(for: taskCell) else { return }
        taskCell.cellAnimateOut { [weak self] in
            self?.model.delete(self?.tasks2d[indexPath.section][indexPath.row])
            self?.tasks2d[indexPath.section].remove(at: indexPath.row)
            self?.taskTableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    
    
    func taskCellDegreeOfProtectionButtonPressed(taskCell: TaskCell) {
        guard let indexPath = taskTableView.indexPath(for: taskCell) else { return }
        let task = tasks2d[indexPath.section][indexPath.row]
        let degreeOfProtectionButton = taskCell.degreeOfProtectionButton
        
        degreeOfProtectionButton.animateDegreeButton(for: degreeOfProtectionButton)
        task.degreeOfProtection = degreeOfProtectionButton.getDegreeProtection(for: degreeOfProtectionButton)
        storageManager.save()
    }
}
