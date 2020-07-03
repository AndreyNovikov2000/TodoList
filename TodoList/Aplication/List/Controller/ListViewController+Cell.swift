//
//  ListViewController+Cell.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit



// MARK: - TaskListCellDelegate
extension ListViewController: TaskListCellDelegate {
    func taskListCellCompliteButtonPressed(_ taskListCell: TaskListCell) {
        guard let indexPath = table.indexPath(for: taskListCell) else { return }
        guard let count = list?.detailLists?.count else { return }
        
        taskListCell.cellAnimateOut { [weak self] in
            self?.deleteCellWith(indexPath: indexPath)
            self?.headerListView.setListCountLabel(with: String(count - 1))
        }
    }
}
