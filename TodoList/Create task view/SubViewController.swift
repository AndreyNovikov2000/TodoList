//
//  ViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/11/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import CoreData

class SubViewController: UIViewController {
    
    // MARK: - Public properties
    var task: Task?
    var heandleDismiss: ((() -> Void)?)
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let storageManager: StoreManager = StorageManager()
    
    private let headerTextView = HeaderTextView()
    private let footerView = FooterView()
    
    private var alarmView: PickerView!
    private var calendarView: PickerCalendaView!
    private var visualEffectView: UIVisualEffectView!
    
    private var components = DateComponents()
    private var calendar = Calendar.current
    private var isNotificate = false
    private var isCreated: Bool!
    
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupHeaderView()
        setupFooterView()
        setupKeyboardNotification()
        
        
        presentationController?.delegate = self
        
        // TASK INIT
        if task != nil {
            isCreated = false
        } else {
            isCreated = true
            task = storageManager.createEntity(entityName: "Task", contex: context)
        }
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
    
    @objc private func addSubTaskButtonPressed() {
        let subTask: SubTask  = storageManager.createEntity(entityName: "SubTask", contex: context)
        
        subTask.subTaskTitle = ""
        subTask.isComplite = false
        
        let subTasks = task?.subTasks?.mutableCopy() as? NSMutableOrderedSet
        
        subTasks?.add(subTask)
        task?.subTasks = subTasks
        storageManager.save(context)
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "SubCell", bundle: nil), forCellReuseIdentifier: SubTaskCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
        tableView.separatorStyle = .none
    }
    
    private func setupHeaderView() {
        // TODO: - LOCALIZE
        headerTextView.text = "Добавить задачу..."
        headerTextView.textColor = .systemGray
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
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboard), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboard), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    private func getSubTask(subTaskCell: SubTaskCell) -> SubTask? {
        guard let indexPath = tableView.indexPath(for: subTaskCell) else { return nil }
        let subTask = task?.subTasks?[indexPath.row] as? SubTask
        
        return subTask
    }
    
    private func setupAlarmView() {
        alarmView = Bundle.main.loadNibNamed("PickerView", owner: nil, options: nil)?.first as? PickerView
        alarmView.center = view.center
        alarmView?.myDelegate = self
        view.addSubview(alarmView)
    }
    
    private func setupCalendarView() {
        calendarView = Bundle.main.loadNibNamed("PickerCalendaView", owner: nil, options: nil)?.first as? PickerCalendaView
        calendarView?.center = view.center
        calendarView.myDelegate = self
        view.addSubview(calendarView!)
    }
    
    private func setupVisualEffectView() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = view.frame
        visualEffectView.effect = UIBlurEffect(style: .dark)
        view.addSubview(visualEffectView)
    }
    
    private func animateIn(for view: UIView) {
        view.visualEffectAnimateIn(visualEffectView: visualEffectView, compliteAnimation: nil)
    }
    
    private func pickerViewAnimateOut() {
        alarmView.visualEffectViewAnimateOut(visualEffectView: visualEffectView) { [weak self] in
            self?.alarmView.removeFromSuperview()
            self?.visualEffectView.removeFromSuperview()
        }
    }
    
    private func calendarViewAnimateOut() {
        calendarView.visualEffectViewAnimateOut(visualEffectView: visualEffectView) { [weak self] in
            self?.calendarView.removeFromSuperview()
            self?.visualEffectView.removeFromSuperview()
        }
    }
    
}


// MARK: - UITableViewDataSource
extension SubViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task?.subTasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubTaskCell.reuseId, for: indexPath) as! SubTaskCell
        let subTask = task?.subTasks?[indexPath.row] as? SubTask
        
        cell.set(subTask: subTask)
        cell.myDelegate = self
        return cell
    }
}


// MARK: - UITableViewDelegate
extension SubViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //        guard let sourceSubTask = task?.subTasks?[sourceIndexPath.row] as? SubTask else { return }
        //        guard let destanationTask = task?.subTasks?[destinationIndexPath.row] as? SubTask else { return }
        //
        //        guard let subTasks = task?.subTasks?.mutableCopy() as? NSMutableOrderedSet else { return }
        //
        //        subTasks.remove(sourceSubTask)
        //        subTasks.insert(destanationTask, at: destinationIndexPath.row)
        //
        //        task?.subTasks = subTasks
        //
        //        storageManager.save(context)
    }
}


// MARK: - SubTaskCellDelegate
extension SubViewController: SubTaskCellDelegate {
    
    func subTaskCellDidComplite(subTaskCell: SubTaskCell) {
        guard let indexPath = tableView.indexPath(for: subTaskCell) else { return }
        let subTask = getSubTask(subTaskCell: subTaskCell)
        
        subTask?.isComplite.toggle()
        storageManager.save(context)
        
        subTaskCell.subTaskTextField.resignFirstResponder()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func subTaskCellDidRemove(subTaskCell: SubTaskCell) {
        guard let indexPath = tableView.indexPath(for: subTaskCell) else { return }
        guard let subTask = task?.subTasks?[indexPath.row] as? SubTask else { return }
        
        let subTasks = task?.subTasks?.mutableCopy() as? NSMutableOrderedSet
        
        subTasks?.remove(subTask)
        context.delete(subTask)
        task?.subTasks = subTasks
        
        storageManager.save(context)
        
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func subTaskCellDidEndEditing(subTaskCell: SubTaskCell) {
        let subTask = getSubTask(subTaskCell: subTaskCell)
        
        subTask?.subTaskTitle = subTaskCell.subTaskTextField.text
        
        storageManager.save(context)
    }
    
    func SubViewController(subTaskCell: SubTaskCell) {
        addSubTaskButtonPressed()
        subTaskCell.subTaskTextField.resignFirstResponder()
    }
}


// MARK: - UITextViewDelegate
extension SubViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let width = tableView.frame.width
        let size = CGSize(width: width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.frame = CGRect(x: 0, y: 0, width: width, height: estimatedSize.height)
        tableView.tableHeaderView = textView
        
        task?.taskTitle = textView.text
        storageManager.save(context)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewDidChange(textView)
        
        if textView.text.isEmpty {
            // FIXME: - Localize
            textView.text = "Добавить задачу..."
            textView.textColor = .systemGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
}


// MARK: - HeaderTextViewDelegate
extension SubViewController: HeaderTextViewDelegate {
    func didCalendarButtonTapped() {
        view.endEditing(true)
        setupVisualEffectView()
        setupCalendarView()
        animateIn(for: calendarView)
    }
    
    func didAlarmButtonPressed() {
        view.endEditing(true)
        setupVisualEffectView()
        setupAlarmView()
        animateIn(for: alarmView)
    }
    
    func didimportanceButtonPressed(sender: UIButton) {
        sender.animateDegreeButton(for: sender)
        task?.degreeOfProtection = sender.getDegreeProtection(for: sender)
        storageManager.save(context)
    }

    
    func didSaveButtonpressed() {
        
        if headerTextView.text.isEmpty {
            headerTextView.shaking()
            return
        }
        
        task?.isNotificate = isNotificate
    
        if isNotificate {
            task?.dateNotification = calendar.date(from: components)
        }
        
        storageManager.save(context)
        
        heandleDismiss?()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - PickerViewDelegate
extension SubViewController: PickerViewDelegate {
    func pickerViewSaveButtonPressed(_ dateComponents: DateComponents) {
        pickerViewAnimateOut()
        
        components.hour = dateComponents.hour
        components.minute = dateComponents.minute
        
        isNotificate = true
    }
    
    func pickerViewCancelButtonPressed() {
        pickerViewAnimateOut()
    }
    
}

// MARK: - PickerCalendarViewDelegate
extension SubViewController: PickerCalendarViewDelegate {
    
    func pickerCalendarViewDidSelectedDate(_ date: Date) {
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
     
        components.setComponents(year: year, month: month, day: day)
    }
    
    func pickerCalendarViewDidDeselectedDate() {
        
    }
    
    func pickerCalendarViewSaveButtonPressed() {
        calendarViewAnimateOut()
        isNotificate = true
    }
    
    func pickerCalendarViewCancelButtonPressed() {
        calendarViewAnimateOut()
        isNotificate = false
        components.setComponents(year: nil, month: nil, day: nil)
    }
    
    func calendarViewClearButtonPressed() {
        isNotificate = false

        components.setComponents(year: nil, month: nil, day: nil)
    }
}

extension SubViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        guard let task = task else { return }
        storageManager.delete(context, object: task)
        storageManager.save(context)
    }
}
