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
    
    private func deleteCell(with indexPath: IndexPath) -> UIContextualAction {
        let task = tasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, complition) in
            if let self = self {
                self.tasks.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.storageManager.delete(self.contex, object: task)
                self.storageManager.save(self.contex)
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
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteCell(with: indexPath)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
