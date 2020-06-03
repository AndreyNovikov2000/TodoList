//
//  SubListViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/28/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class SubListViewController: UIViewController {
    
    // MARK: - Public properties
    var heandleDismiss: ((DetailList?) -> Void)?
    var detailList: DetailList?
    
    
    // optinal
    var listColor: UIColor?
    
    // MARK: - IBOutlets
    private let textView = ListTextView()
    
    // MARK: - Private properties
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let storageManager: StoreManager = StorageManager()
    
    
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
        
        setupKeyboardNotification()
        setupTextView()
        
        view.backgroundColor = listColor
        
        // List INIT
        if detailList != nil {
            isCreated = false
        } else {
            isCreated = true
            detailList = storageManager.createEntity(entityName: "DetailList", contex: context)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Action
    @objc private func heandleKeyboardNotification(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 50, right: 0)
            textView.contentInset = insets
        } else {
            let insets: UIEdgeInsets = .zero
            textView.contentInset = insets
        }
    }
    
    // MARK: - Private methods
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTextView() {
        textView.frame = view.frame
        textView.becomeFirstResponder()
        textView.myDelegate = self
        view.addSubview(textView)
    }
    
    private func setupAlarmView() {
        alarmView = .loadFromNib()
        alarmView.myDelegate = self
        alarmView.center = view.center
        view.addSubview(alarmView)
    }
    
    private func setupCalendarView() {
        calendarView = .loadFromNib()
        calendarView.myDelegate = self
        calendarView.center = view.center
        view.addSubview(calendarView)
    }
    
    private func setupVisualEffectView() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.effect = UIBlurEffect(style: .dark)
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
    }
    
    
    private func animateIn(for view: UIView) {
        view.visualEffectAnimateIn(duration: 0.4, visualEffectView: visualEffectView, compliteAnimation: nil)
    }
    
    private func childViewAnimateOut(childView: UIView) {
        childView.visualEffectViewAnimateOut(duration: 0.4, visualEffectView: visualEffectView) { [weak self] in
            childView.removeFromSuperview()
            self?.visualEffectView.removeFromSuperview()
        }
    }
}


// MARK: - ListTextViewDelegate
extension SubListViewController: ListTextViewDelegate {
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
        
        if textView.text.isEmpty {
            textView.shaking()
            return
        }
        
        if isNotificate {
            let date = calendar.date(from: components)
            detailList?.notificationDate = date
        }
        detailList?.title = textView.text
        detailList?.isNotificate = isNotificate
        
        storageManager.save(context)
        heandleDismiss?(detailList)
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - PickerViewDelegate
extension SubListViewController: PickerViewDelegate {
    func pickerViewSaveButtonPressed(_ dateComponents: DateComponents) {
        components.hour = dateComponents.hour
        components.minute = dateComponents.minute
        
        childViewAnimateOut(childView: alarmView)
        textView.becomeFirstResponder()
    }
    
    func pickerViewCancelButtonPressed() {
        
        childViewAnimateOut(childView: alarmView)
        textView.becomeFirstResponder()
    }
}


// MARK: - PickerCalendarViewDelegate
extension SubListViewController: PickerCalendarViewDelegate {
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
