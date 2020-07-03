//
//  TaskViewController+taskTable+Drag.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

// MARK: - UITableViewDragDelegate
extension TaskViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return model.getDragItems(with: tasks2d, for: indexPath)
    }
}
