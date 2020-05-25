//
//  TaskTableView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class TaskTableView: UITableView {
    
    // MARK: - Private properties
    private let footerView = FooterListView()
    private var tasks = [Task]()
    
    private let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let storageManager = StorageManager()
    
    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)
        fetchTasks()
    
        setupTableView()
        setupFooterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public properties
    func updateData() {
        fetchTasks()
        reloadData()
    }
    
    // MARK: - Private methods
    private func setupTableView() {
        register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseId)
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
        separatorStyle = .none
    }
    
    private func setupFooterView() {
        footerView.backgroundColor = .clear
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
        // TODO: - Localize
        footerView.setFooterText(text: "Lists")
        tableFooterView = footerView

    }
    
    private func deleteContextualAction(with indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, complition) in
            if let self = self {
                self.deleteCellWith(indexPath: indexPath)
                complition(true)
            }
        }
    
        deleteAction.backgroundColor = UIColor(red: 0.9568627451, green: 0.368627451, blue: 0.4274509804, alpha: 1)
        deleteAction.image = UIImage(systemName: "trash")
        
        return deleteAction
    }
        
    private func deleteCellWith(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        
        tasks.remove(at: indexPath.row)
        deleteRows(at: [indexPath], with: .left)
        storageManager.delete(contex, object: task)
        storageManager.save(contex)
    }
    
    private func fetchTasks() {
        do {
            tasks = try storageManager.request(contex: contex)
        } catch let error as NSError {
            print("error - \(error.userInfo)")
        }
    }
}

// MARK: - UITableViewDataSource
extension TaskTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseId, for: indexPath) as! TaskCell
        
        let task = tasks[indexPath.row]
        
        cell.set(task: task)
        cell.myDelegate = self
        
        return cell
    }
}

extension TaskTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteContextualAction(with: indexPath)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        headerView.setHeaderText(text: "Today")

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}

// MARK: - TaskCellDelegate
extension TaskTableView: TaskCellDelegate {
    func taskCellDidComplite(taskCell: TaskCell) {
        guard let indexPath = indexPath(for: taskCell) else { return }
        deleteCellWith(indexPath: indexPath)
    }
    
    func taskCellDegreeOfProtectionButtonPressed(taskCell: TaskCell) {
        guard let indexPath = indexPath(for: taskCell) else { return }
        let task = tasks[indexPath.row]
        let degreeOfProtectionButton = taskCell.degreeOfProtectionButton
        
        degreeOfProtectionButton.animateDegreeButton(for: degreeOfProtectionButton)
        task.degreeOfProtection = degreeOfProtectionButton.getDegreeProtection(for: degreeOfProtectionButton)
    
        storageManager.save(contex)
    }
}
