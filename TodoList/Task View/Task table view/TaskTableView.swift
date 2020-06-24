//
//  TaskTableView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class TaskTableView: UITableView {
    
    // MARK: - Public properties
    var presentationClosure: ((Task) -> Void)?
    let footerView = FooterListView()
    let headerView = HeaderStoryView()
    
    // MARK: - Private properties
    private var tasks = [Task]()
    private var tasks2d = [[Task]]()
    
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
        
        print(#function)
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
        let task = tasks2d[indexPath.section][indexPath.row]
        
        tasks2d[indexPath.section].remove(at: indexPath.row)
        deleteRows(at: [indexPath], with: .left)
        storageManager.delete(contex, object: task)
        storageManager.save(contex)
    }
    
    private func fetchTasks() {
        do {
            
            let sortDescriptor = NSSortDescriptor(key: "orderPosition", ascending: true)
            tasks = try storageManager.request(contex: contex, descriptors: [sortDescriptor])
            getTask2d()
            
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    
    
    func getTask2d() {
        tasks2d.removeAll()
        
        var todayTasks = [Task]()
        var tomorrowTasks = [Task]()
        var laterTasks = [Task]()
        
        let todayDate = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        let tomorrowDate = calendar.date(byAdding: dateComponents, to: todayDate)!
        
        for task in tasks {
            let dateNotification = task.dateNotification ?? Date()
            
            let taskDay = calendar.component(.day, from: dateNotification)
            let today = calendar.component(.day, from: todayDate)
            let tomorrow = calendar.component(.day, from: tomorrowDate)
            
            switch taskDay {
            case today:
                todayTasks.append(task)
            case tomorrow:
                tomorrowTasks.append(task)
            default:
                laterTasks.append(task)
            }
        }
        
        tasks2d.append(todayTasks)
        tasks2d.append(tomorrowTasks)
        tasks2d.append(laterTasks)
        
        for (index ,todayTask) in todayTasks.enumerated() {
            todayTask.orderPosition = Int64(index)
        }
        
        for (index ,todayTask) in todayTasks.enumerated() {
            todayTask.orderPosition = Int64(index)
        }
        
        for (index ,tomorrowTask) in tomorrowTasks.enumerated() {
            tomorrowTask.orderPosition = Int64(index * 1000)
        }
        
        for (index ,laterTasks) in laterTasks.enumerated() {
            laterTasks.orderPosition = Int64(index * 10000)
        }
        
        storageManager.save(contex)
    }
    
    private func moveRow(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let calendar = Calendar.current
        let changeTask = tasks2d[destinationIndexPath.section][destinationIndexPath.row]
        let taskDate = changeTask.dateNotification ?? Date()
        
        switch (sourceIndexPath, destinationIndexPath) {
        case let (source, destination) where source.section == destination.section:
            // section does not change, today = today, tomorrow = tomorrow, later = later
            
            for (index, task) in tasks2d[sourceIndexPath.section].enumerated() {
                switch sourceIndexPath.section {
                case 0: task.orderPosition = Int64(index)
                case 1: task.orderPosition = Int64(index * 1000)
                case 2: task.orderPosition = Int64(index * 10000)
                default: break
                }
            }
            
        case let (source, destination) where source.section == 0 && destination.section == 1:
            // move from today section to tomorrow section
            
            changeTask.dateNotification = calendar.replaceDate(fromDate: taskDate, byAdding: 1)
            for (index, task) in tasks2d[destination.section].enumerated() {
                task.orderPosition = Int64(index * 1000)
            }
            
        case let (source, destination) where source.section == 0 && destination.section == 2:
            // move from today section to later section
            
            changeTask.dateNotification = calendar.replaceDate(fromDate: taskDate, byAdding: 7)
            for (index, task) in tasks2d[destination.section].enumerated() {
                task.orderPosition = Int64(index * 10000)
            }
            
        case let (source, destination) where source.section == 1 && destination.section == 0:
            // move from tomorrow section to today section
            
            changeTask.dateNotification = calendar.replaceDate(fromDate: taskDate, byAdding: -1)
            for (index, task) in tasks2d[destination.section].enumerated() {
                task.orderPosition = Int64(index)
            }
            
        case let (source, destination) where source.section == 1 && destination.section == 2:
            // move from tomorrow section to later section
            
            changeTask.dateNotification = calendar.replaceDate(fromDate: taskDate, byAdding: 6)
            for (index, task) in tasks2d[destination.section].enumerated() {
                task.orderPosition = Int64(index * 10000)
            }
            
        case let (source, destination) where source.section == 2 && destination.section == 0:
            // move from later section to today section
            
            let today = Date()
            var components = DateComponents()

            components.year = calendar.component(.year, from: today)
            components.month = calendar.component(.month, from: today)
            components.day = calendar.component(.day, from: today)
            components.hour = calendar.component(.hour, from: taskDate)
            components.minute = calendar.component(.minute, from: taskDate)

            let newTodayDate = calendar.date(from: components)

            changeTask.dateNotification = newTodayDate
            
            for (index, task) in tasks2d[destination.section].enumerated() {
                task.orderPosition = Int64(index)
            }
            
        case let (source, destination) where source.section == 2 && destination.section == 1:
            // move from later section to tomorrow section
            
                let today = Date()
                var components = DateComponents()

                components.year = calendar.component(.year, from: today)
                components.month = calendar.component(.month, from: today)
                components.day = calendar.component(.day, from: today)
                components.hour = calendar.component(.hour, from: taskDate)
                components.minute = calendar.component(.minute, from: taskDate)

                let newTodayDate = calendar.date(from: components)
                
                changeTask.dateNotification = calendar.replaceDate(fromDate: newTodayDate, byAdding: 1)
                
                for (index, task) in tasks2d[destination.section].enumerated() {
                    task.orderPosition = Int64(index)
                }
            
        default:
            break
        }
        
        reloadData()
    }
}


// MARK: - UITableViewDataSource
extension TaskTableView: UITableViewDataSource {
    
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
extension TaskTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteContextualAction(with: indexPath)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
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
        presentationClosure?(task)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        
        let deletedObject = tasks2d[sourceIndexPath.section][sourceIndexPath.row]
        tasks2d[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        tasks2d[destinationIndexPath.section].insert(deletedObject, at: destinationIndexPath.row)
        
        moveRow(from: sourceIndexPath, to: destinationIndexPath)
        
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
        let task = tasks2d[indexPath.section][indexPath.row]
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
}

extension Calendar {
    func replaceDate(fromDate: Date?, byAdding day: Int) -> Date? {
        guard let fromDate = fromDate else { return Date() }
        let calendar = Calendar.current
        var componets = DateComponents()
        componets.day = day
        
        return calendar.date(byAdding: componets, to: fromDate)
    }
}
