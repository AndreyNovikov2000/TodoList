//
//  CreateTaskViewController+Views.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


// MARK: - SubTaskCellDelegate
extension CreateTaskViewController: SubTaskCellDelegate {
    
    func subTaskCellDidComplite(subTaskCell: SubTaskCell) {
        guard let indexPath = tableView.indexPath(for: subTaskCell) else { return }
        let subTask = getSubTask(subTaskCell: subTaskCell)
        
        subTask?.isComplite.toggle()
        
        subTaskCell.subTaskTextField.resignFirstResponder()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func subTaskCellDidRemove(subTaskCell: SubTaskCell) {
        guard let indexPath = tableView.indexPath(for: subTaskCell) else { return }
        guard let subTask = task?.subTasks?[indexPath.row] as? SubTask else { return }
        
        let subTasks = task?.subTasks?.mutableCopy() as? NSMutableOrderedSet
        
        subTasks?.remove(subTask)
        storageManager.delete(object: subTask)
        task?.subTasks = subTasks
        
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func subTaskCellDidEndEditing(subTaskCell: SubTaskCell) {
        let subTask = getSubTask(subTaskCell: subTaskCell)
        
        subTask?.subTaskTitle = subTaskCell.subTaskTextField.text
    }
    
    func SubViewController(subTaskCell: SubTaskCell) {
        addSubTaskButtonPressed()
        subTaskCell.subTaskTextField.resignFirstResponder()
    }
}


// MARK: - UITextViewDelegate
extension CreateTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let width = tableView.frame.width
        let size = CGSize(width: width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.frame = CGRect(x: 0, y: 0, width: width, height: estimatedSize.height)
        tableView.tableHeaderView = textView
    }
}


// MARK: - HeaderTextViewDelegate
extension CreateTaskViewController: HeaderTextViewDelegate {
    func headerTextViewDidCalendarButtonTapped() {
        view.endEditing(true)
        setupVisualEffectView()
        setupCalendarView()
        animateIn(for: calendarView)
    }
    
    func headerTextViewdidAlarmButtonPressed() {
        view.endEditing(true)
        setupVisualEffectView()
        setupAlarmView()
        animateIn(for: alarmView)
    }
    
    func headerTextViewDidimportanceButtonPressed(sender: UIButton) {
        sender.animateDegreeButton(for: sender)
        task?.degreeOfProtection = sender.getDegreeProtection(for: sender)
    }
    
    func headerxtViewDidSaveButtonpressed() {
        if headerTextView.text.isEmpty || headerTextView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            headerTextView.shaking()
            return
        }
        
        saveTask()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - PickerViewDelegate
extension CreateTaskViewController: PickerViewDelegate {
    func pickerView(_ pickerView: PickerView, saveButtonPressedWith dateComponents: DateComponents) {
        components.hour = dateComponents.hour
        components.minute = dateComponents.minute
        
        isNotificate = true
        pickerViewAnimateOut()
        headerTextView.becomeFirstResponder()
    }
    
    func pickerViewCancelButtonPressed() {
        isNotificate = false
        pickerViewAnimateOut()
        headerTextView.becomeFirstResponder()
    }
    
    func pickerViewClearButtonPressed(_ pickerView: PickerView) {
        
    }
    
}

// MARK: - PickerCalendarViewDelegate
extension CreateTaskViewController: PickerCalendarViewDelegate {
    
    func pickerCalendarViewSaveButtonPressed(date: Date) {
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        isNotificate = true
        components.setComponents(year: year, month: month, day: day)
        calendarViewAnimateOut()
        headerTextView.becomeFirstResponder()
    }
    
    func pickerCalendarViewCancelButtonPressed() {
        isNotificate = false
        calendarViewAnimateOut()
        headerTextView.becomeFirstResponder()
    }
    
    func picerCalendarViewClearButtonPressed() {
        isNotificate = false
    }
}
