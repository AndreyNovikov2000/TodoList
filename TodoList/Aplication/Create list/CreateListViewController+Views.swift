//
//  CreateListViewController+Views.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/4/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


// MARK: - ListTextViewDelegate
extension CreateListViewController: ListTextViewDelegate {
    func listTextViewCalendarButtonPressed(_ listTextView: ListTextView) {
        textView.resignFirstResponder()
        
        setupVisualEffectView()
        setupCalendarView()
        animateIn(for: calendarView)
    }
    
    func listTextViewAlarmButtonPressed(_ listTextView: ListTextView) {
        textView.resignFirstResponder()
        
        setupVisualEffectView()
        setupAlarmView()
        animateIn(for: alarmView)
    }
    
    func listTextViewSaveButtonPressed(_ listTextView: ListTextView) {
        saveTask()
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - PickerViewDelegate
extension CreateListViewController: PickerViewDelegate {
    func pickerView(_ pickerView: PickerView, saveButtonPressedWith dateComponents: DateComponents) {
        components.hour = dateComponents.hour
        components.minute = dateComponents.minute
        
        childViewAnimateOut(childView: alarmView)
        textView.becomeFirstResponder()
    }
    
    
    func pickerViewCancelButtonPressed() {
        
        childViewAnimateOut(childView: alarmView)
        textView.becomeFirstResponder()
    }
    
    func pickerViewClearButtonPressed(_ pickerView: PickerView) {
        
    }
}


// MARK: - PickerCalendarViewDelegate
extension CreateListViewController: PickerCalendarViewDelegate {
    func pickerCalendarViewSaveButtonPressed(date: Date) {
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        components.day = day
        components.month = month
        components.year = year
        
        childViewAnimateOut(childView: calendarView)
        textView.becomeFirstResponder()
        
        isNotificate = true
    }
    
    func pickerCalendarViewCancelButtonPressed() {
        
        childViewAnimateOut(childView: calendarView)
        textView.becomeFirstResponder()
    }
    
    func picerCalendarViewClearButtonPressed() {
        
    }
}
