//
//  TaskTableView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import CoreData

class TaskTableView: UITableView {
    
    // MARK: - Public properties
    var presentationClosure: ((Task) -> Void)?
    let footerView = FooterListView()
    let headerView = HeaderStoryView()
    
    // MARK: - Private properties
    private var tasks = [Task]()
    
    private let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let storageManager = StorageManager()
    
    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)
        fetchTasks()
        
        setupTableView()
        setupHeaderView()
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
        separatorStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        dragInteractionEnabled = true
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
        dragDelegate = self
        dropDelegate = self
    }
    
    private func setupFooterView() {
        footerView.backgroundColor = .clear
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
        // TODO: - Localize
        footerView.setFooterText(text: "Lists")
        tableFooterView = footerView
    }
    
    private func setupHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        tableHeaderView = headerView
    }
    
    private func getDragItems(for indexPath: IndexPath) -> [UIDragItem]  {
        let task = tasks[indexPath.row]
        let data = try! NSKeyedArchiver.archivedData(withRootObject: task, requiringSecureCoding: false)
        let itemProvider = NSItemProvider()
        itemProvider.registerDataRepresentation(forTypeIdentifier: "id" , visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
    
    private func addItem(_ place: Task, at index: Int) {
        tasks.insert(place, at: index)
    }
    
    func canHndle(_ session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: NSString.self)
    }
    
    private func deleteContextualAction(with indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, complition) in
            if let self = self {
                self.deleteCellWith(indexPath: indexPath)
                complition(true)
            }
        }
        
        deleteAction.backgroundColor = UIColor(red: 0.9568627451, green: 0.368627451, blue: 0.4274509804, alpha: 1)
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        } else {
            // FIXME: - SET IMAGE
            // Fallback on earlier versions
        }
        
        return deleteAction
    }
    
    private func deleteCellWith(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        
        tasks.remove(at: indexPath.row)
        deleteRows(at: [indexPath], with: .left)
        storageManager.delete(contex, object: task)
    }
    
    private func fetchTasks() {
        do {
            
            let sortDescriptor = NSSortDescriptor(key: "orderPosition", ascending: true)
            tasks = try storageManager.request(contex: contex, descriptors: [sortDescriptor])
            
            for (index, task) in tasks.enumerated() {
                task.orderPosition = Int64(index)
            }
            
        } catch let error as NSError {
            print(error.userInfo)
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


// MARK: - UITableViewDelegate
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        presentationClosure?(task)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        
        let deletedObject = tasks[sourceIndexPath.row]
        
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(deletedObject, at: destinationIndexPath.row)
        
        for (index, task) in tasks.enumerated() {
            task.orderPosition = Int64(index)
        }

        storageManager.save(contex)
    }
}


// MARK: - TaskCellDelegate
extension TaskTableView: TaskCellDelegate {
    func taskCellDidComplite(taskCell: TaskCell) {
        guard let indexPath = indexPath(for: taskCell) else { return }
        taskCell.cellAnimateOut { [weak self] in
            self?.deleteCellWith(indexPath: indexPath)
        }
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


// MARK: - UITableViewDragDelegate
extension TaskTableView: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        getDragItems(for: indexPath)
    }
}

// MARK: - UITableViewDropDelegate
extension TaskTableView: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        canHndle(session)
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if tableView.hasActiveDrag {

            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return  UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: Task.self as! NSItemProviderReading.Type) { items in
            let tasks = items as! [Task]
            var indexPaths = [IndexPath]()
            
            for (index, item) in tasks.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                self.addItem(item, at: indexPath.row)
                indexPaths.append(indexPath)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {
    
    }
}
