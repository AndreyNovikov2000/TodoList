//
//  ViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/11/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

struct TaskVC {
    let taskTitle: String
    let subTasks: [SubTask]
}


struct SubTask {
    var subTaskTitle: String
    var isComplite: Bool
}

class SubViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let headerView = HeaderTextView()
    let footerView = FooterView()
    
    
    // MARK: - Private properties
    private var subTasks = [SubTask]()
    private var degreeOfProtection = 0
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTableView()
        setupHeaderView()
        setupFooterView()
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboard), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboard), name: UIWindow.keyboardWillHideNotification, object: nil)
        
        
        subTasks.append(SubTask(subTaskTitle: "Hello", isComplite: true))
        subTasks.append(SubTask(subTaskTitle: "hello2", isComplite: false))
    }
    
    
    // MARK: - Objc methods
    
    @objc private func heandleKeyboard(notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]) as? CGRect else { return }
        
        let tableViewBottomInset = (headerView.inputAccessoryView?.frame.height ?? 0) + keyboardFrame.height + headerView.frame.height + 10
        
        if notification.name == UIWindow.keyboardWillShowNotification {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableViewBottomInset, right: 0)
        } else {
            tableView.contentInset = UIEdgeInsets.zero
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    @objc private func addSubTaskButtonPressed() {
        
        let subTask = SubTask(subTaskTitle: "", isComplite: false)
        subTasks.append(subTask)
        tableView.reloadData()
        
        resignFirstResponderForLastCell()
    }
    
    private func resignFirstResponderForLastCell() {
        let section = tableView.numberOfSections - 1
        let row = tableView.numberOfRows(inSection: section) - 1
        let indexPath = IndexPath(row: row, section: section)
        
        if  let cell = tableView.cellForRow(at: indexPath) as? SubTaskCell {
            cell.subTaskTextField.resignFirstResponder()
        }
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
        headerView.text = "Добавить задачу..."
        headerView.textColor = .systemGray
        headerView.myDelegate = self
        headerView.delegate = self
        headerView.frame = CGRect.zero
        textViewDidChange(headerView)
    }
    
    private func setupFooterView() {
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        footerView.footerButton.addTarget(self, action: #selector(addSubTaskButtonPressed), for: .touchUpInside)
        tableView.tableFooterView = footerView
    }
}


// MARK: - UITableViewDataSource
extension SubViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubTaskCell.reuseId, for: indexPath) as! SubTaskCell
        let subTask = subTasks[indexPath.row]

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
        let sourceItem = subTasks[sourceIndexPath.row]
        
        subTasks.remove(at: sourceIndexPath.row)
        subTasks.insert(sourceItem, at: destinationIndexPath.row)
        // FIXME: - SAVE CORE DATA
    }
}


// MARK: - SubTaskCellDelegate
extension SubViewController: SubTaskCellDelegate {
    
    func subTaskCellDidComplite(subTaskCell: SubTaskCell) {
        guard let indexPath = tableView.indexPath(for: subTaskCell) else { return }
        
        subTaskCell.subTaskTextField.becomeFirstResponder()
        subTasks[indexPath.row].isComplite.toggle()
        tableView.reloadRows(at: [indexPath], with: .none)
        
        subTaskCell.subTaskTextField.resignFirstResponder()
        // FIXME: - SAVE CORE DATA EDIT
    }
    
    func subTaskCellDidRemove(subTaskCell: SubTaskCell) {
        guard let indexPath = tableView.indexPath(for: subTaskCell) else { return }
        
        subTasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        resignFirstResponderForLastCell()
        
        // FIXME: - SAVE CORE DATA DELETE
    }
    
    func subTaskCellDidEndEditing(subTaskCell: SubTaskCell) {
        guard let indexPath = tableView.indexPath(for: subTaskCell) else { return }
        
        subTasks[indexPath.row].subTaskTitle = subTaskCell.subTaskTextField.text ?? ""
        
        // FIXME: - SAVE CORE DATA EDIT
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
        print("Calendar")
    }
    
    func didAlarmButtonPressed() {
        print("Alarm")
    }
    
    func didimportanceButtonPressed(sender: UIButton) {
        
        Animation.animateDegreeButton(for: sender)
        
        switch sender.image(for: .normal) {
        case UIImage(named: "lMarkOne"):
            sender.setImage(UIImage(named: "lMarkTwo"), for: .normal)
            degreeOfProtection = 1
        case UIImage(named: "lMarkTwo"):
            sender.setImage(UIImage(named: "lMarkThree"), for: .normal)
            degreeOfProtection = 2
        case UIImage(named: "lMarkThree"):
            sender.setImage(UIImage(named: "lMarkOne"), for: .normal)
            degreeOfProtection = 0
        default:
            break
        }
        
    }
    
    func didSaveButtonpressed() {
        dismiss(animated: true, completion: nil)
    }
}

