//
//  TaskViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    // MARK: - IBOultets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewTaskButton: UIButton!
    
    private let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let storageManager = StorageManager()
    var tasks = [Task]()
    
    // MARK: - Live Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchTasks()
        
        setupTableView()
        setupAddButton()
        
        let headerView = UIView()
        headerView.backgroundColor = .red
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 115)
        
        let label = UILabel()
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.text = "setupAddButton() {setupAddButton() {setupAddButton() {setupAddButton() {"
        label.numberOfLines = 0
        tableView.tableHeaderView = headerView
        
        let footerView = UIView()
        footerView.backgroundColor = .green
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        
        tableView.tableFooterView = footerView
    }
    
    
    // MARK: - IBACtion
    @IBAction func heandleNewTaskButtonPressed() {
        let vc = SubViewController()
        vc.modalPresentationStyle = .pageSheet
      
        vc.heandleDismiss = {
            self.fetchTasks()
            self.tableView.reloadData()
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    private func setupAddButton() {
        addNewTaskButton.layer.cornerRadius = addNewTaskButton.frame.height / 2
        addNewTaskButton.setTitle("", for: .normal)
        addNewTaskButton.backgroundColor = .black
        addNewTaskButton.setImage(UIImage(named: "AddShape"), for: .normal)
    }
    
    private func setupTableView() {
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    
    
    private func deleteContextualAction(with indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] (_, _, complition) in
            if let self = self {
                self.deleteCellWith(indexPath: indexPath)
                complition(true)
            }
        }
    
        deleteAction.backgroundColor = UIColor(red: 0.9568627451, green: 0.368627451, blue: 0.4274509804, alpha: 1)
        deleteAction.image = UIImage(systemName: "trash")
        
        return deleteAction
    }
    
    private func fetchTasks() {
        do {
            tasks = try storageManager.request(contex: contex)
        } catch let error as NSError {
            print("error - \(error.userInfo)")
        }
    }
    
    private func deleteCellWith(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        storageManager.delete(self.contex, object: task)
        storageManager.save(self.contex)
    }
}

// MARK: - UITableViewDataSource
extension TaskViewController: UITableViewDataSource {
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


// MARK: - UITableViewDelegate
extension TaskViewController: UITableViewDelegate {
    
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

extension TaskViewController: TaskCellDelegate {
    func taskCellDidComplite(taskCell: TaskCell) {
        guard let indexPath = tableView.indexPath(for: taskCell) else { return }
        deleteCellWith(indexPath: indexPath)
    }
    
    func taskCellDegreeOfProtectionButtonPressed(taskCell: TaskCell) {
        guard let indexPath = tableView.indexPath(for: taskCell) else { return }
        let task = tasks[indexPath.row]
        let degreeOfProtectionButton = taskCell.degreeOfProtectionButton
        
        degreeOfProtectionButton.animateDegreeButton(for: degreeOfProtectionButton)
        task.degreeOfProtection = degreeOfProtectionButton.getDegreeProtection(for: degreeOfProtectionButton)
    
        storageManager.save(contex)
    }
}
