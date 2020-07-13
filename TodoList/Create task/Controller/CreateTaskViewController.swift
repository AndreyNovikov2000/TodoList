//
//  ViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/11/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import CoreData

class CreateTaskViewController: UIViewController {
    
    
    // MARK: - Public properties
    let storageManager: StoreManager = StorageManager()
    let model = TaskModel()
    var heandleDismiss: ((() -> Void)?)
    
    var task: Task!
    var alarmView: PickerView!
    var calendarView: PickerCalendarView!
    let headerTextView = HeaderTextView()
    var components = DateComponents()
    var calendar = Calendar.current
    var isNotificate = false
    var isCreated = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heandleView: UIView!
    
    // MARK: - Private properties
    private let footerView = FooterView()
    private var visualEffectView: UIVisualEffectView!
    
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupHeaderView()
        setupFooterView()
        setupHeandleView()
        setupKeyboardNotification()
        setupTask()
        
        presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Objc methods
    
    @objc private func heandleKeyboard(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]) as? CGRect else { return }
        
        let totalHeight = keyboardFrame.height + (headerTextView.inputAccessoryView?.frame.height ?? 0)
        
        if notification.name == UIWindow.keyboardWillShowNotification {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: totalHeight, right: 0)
        } else {
            tableView.contentInset = UIEdgeInsets.zero
        }
    }
    
    @objc func addSubTaskButtonPressed() {
        let subTask: SubTask  = storageManager.createEntity(entityName: "SubTask")
        
        subTask.subTaskTitle = ""
        subTask.isComplite = false
        
        let subTasks = task?.subTasks?.mutableCopy() as? NSMutableOrderedSet
        
        subTasks?.add(subTask)
        task?.subTasks = subTasks
        tableView.reloadData()
    }
    
    // MARK: - Public properties
    
    func getSubTask(subTaskCell: SubTaskCell) -> SubTask? {
        guard let indexPath = tableView.indexPath(for: subTaskCell) else { return nil }
        let subTask = task?.subTasks?[indexPath.row] as? SubTask
        
        return subTask
    }
    
    func setupAlarmView() {
        alarmView = .loadFromNib()
        alarmView.center = view.center
        alarmView?.myDelegate = self
        view.addSubview(alarmView)
    }
    
    func setupCalendarView() {
        calendarView = .loadFromNib()
        calendarView?.center = view.center
        calendarView.myDelegate = self
        view.addSubview(calendarView!)
    }
    
    func setupVisualEffectView() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = view.frame
        visualEffectView.effect = UIBlurEffect(style: .dark)
        view.addSubview(visualEffectView)
    }
    
    func animateIn(for view: UIView) {
        view.visualEffectAnimateIn(duration: 0.4, visualEffectView: visualEffectView, compliteAnimation: nil)
    }
    
    func pickerViewAnimateOut() {
        alarmView.visualEffectViewAnimateOut(duration: 0.4, visualEffectView: visualEffectView) { [weak self] in
            self?.alarmView.removeFromSuperview()
            self?.visualEffectView.removeFromSuperview()
        }
    }
    
    
    func calendarViewAnimateOut() {
        calendarView.visualEffectViewAnimateOut(duration: 0.4, visualEffectView: visualEffectView) { [weak self] in
            self?.calendarView.removeFromSuperview()
            self?.visualEffectView.removeFromSuperview()
        }
    }
    
    func saveTask() {
        guard !headerTextView.text.isEmpty || !headerTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            storageManager.delete(object: task)
            return
        }
        
        task?.taskTitle = headerTextView.text
        task?.isNotificate = isNotificate
        
        
        if isCreated {
            task?.orderPosition = Int64.max
        }
        
        if isNotificate {
            task?.dateNotification = calendar.date(from: components)
            model.setCalendarNotification(with: task, dateComponets: components)
        } else {
            task?.dateNotification = Date()
        }
        
        storageManager.save()
        heandleDismiss?()
    }

    
    // MARK: - Private methods
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "SubTaskCell", bundle: nil), forCellReuseIdentifier: SubTaskCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
        tableView.separatorStyle = .none
    }
    
    private func setupHeaderView() {
        headerTextView.text = task?.taskTitle
        headerTextView.myDelegate = self
        headerTextView.delegate = self
        headerTextView.frame = CGRect.zero
        textViewDidChange(headerTextView)
    }
    
    private func setupFooterView() {
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        footerView.footerButton.addTarget(self, action: #selector(addSubTaskButtonPressed), for: .touchUpInside)
        tableView.tableFooterView = footerView
    }
    
    private func setupHeandleView() {
        heandleView.backgroundColor = UIColor(red: 0.145, green: 0.165, blue: 0.192, alpha: 1)
        heandleView.alpha = 0.2
        heandleView.layer.cornerRadius = 3
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboard), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboard), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTask() {
        if task != nil {
            isCreated = false
            
            if let date = task?.dateNotification {
                isNotificate = true
                let dateComponents = calendar.getComponents(from: date)
                components = dateComponents
            }
        } else {
            let id = UUID().uuidString
            isCreated = true
            task = storageManager.createEntity(entityName: "Task")
            task.taskId = id
        }
    }
}
