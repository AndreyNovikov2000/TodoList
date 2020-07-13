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
        if textView.text.isEmpty || textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.shaking()
            return
        }
        saveTask()
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - PickerViewDelegate
extension CreateListViewController: PickerViewDelegate {
    func pickerView(_ pickerView: PickerView, saveButtonPressedWith dateComponents: DateComponents) {
        components.setComponentsTime(hour: dateComponents.hour, minute: dateComponents.minute)
        childViewAnimateOut(childView: alarmView)
        textView.becomeFirstResponder()
    }
    
    
    func pickerViewCancelButtonPressed() {
        childViewAnimateOut(childView: alarmView)
        textView.becomeFirstResponder()
    }
    
    func pickerViewClearButtonPressed(_ pickerView: PickerView) {
        components.setComponentsTime(hour: nil, minute: nil)
    }
}


// MARK: - PickerCalendarViewDelegate
extension CreateListViewController: PickerCalendarViewDelegate {
    func pickerCalendarView(_ pickercalendarViewdate: PickerCalendarView, didSelectedDate date: Date) {
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        components.setComponentsDate(year: year, month: month, day: day)
        childViewAnimateOut(childView: calendarView)
        textView.becomeFirstResponder()
    }
    
    func pickerCalendarViewCancelButtonPressed(_ pickerCalendarView: PickerCalendarView) {
        childViewAnimateOut(childView: calendarView)
        textView.becomeFirstResponder()
    }
    
    func picerCalendarViewClearButtonPressed(_ pickerCalendarView: PickerCalendarView) {
        components.setComponentsDate(year: nil, month: nil, day: nil)
    }
}
