//
//  SubListViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/28/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class CreateListViewController: UIViewController {
    
    // MARK: - Public properties
    var heandleDismiss: ((DetailList?) -> Void)?
    var detailList: DetailList?
    var listColor: UIColor?
    let textView = ListTextView()
    var alarmView: PickerView!
    var calendarView: PickerCalendaView!
    var components = DateComponents()
    var calendar = Calendar.current
    var isNotificate = false
    
    
    
    // MARK: - Private properties
    private let storageManager: StoreManager = StorageManager()
    private let heandleView = UIView()
    private var visualEffectView: UIVisualEffectView!
    private var isCreated: Bool!
    
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardNotification()
        setupTextView()
        setupHeandleView()
        setupList()
        
        presentationController?.delegate = self
        view.backgroundColor = listColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Objc methods
    
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
    
    
    // MARK: - Public methods
    
    func setupAlarmView() {
        alarmView = .loadFromNib()
        alarmView.myDelegate = self
        alarmView.center = view.center
        view.addSubview(alarmView)
    }
    
    func setupCalendarView() {
        calendarView = .loadFromNib()
        calendarView.myDelegate = self
        calendarView.center = view.center
        view.addSubview(calendarView)
    }
    
    func setupVisualEffectView() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.effect = UIBlurEffect(style: .dark)
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
    }
    
    
    func animateIn(for view: UIView) {
        view.visualEffectAnimateIn(duration: 0.4, visualEffectView: visualEffectView, compliteAnimation: nil)
    }
    
    func childViewAnimateOut(childView: UIView) {
        childView.visualEffectViewAnimateOut(duration: 0.4, visualEffectView: visualEffectView) { [weak self] in
            childView.removeFromSuperview()
            self?.visualEffectView.removeFromSuperview()
        }
    }
    
    func saveTask() {
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
        
        storageManager.save()
        heandleDismiss?(detailList)
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
    
    private func setupHeandleView() {
        view.addSubview(heandleView)
        heandleView.backgroundColor = UIColor(red: 0.145, green: 0.165, blue: 0.192, alpha: 1)
        heandleView.alpha = 0.2
        heandleView.layer.cornerRadius = 3
        heandleView.translatesAutoresizingMaskIntoConstraints = false
        
        heandleView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        heandleView.widthAnchor.constraint(equalToConstant: 37).isActive = true
        heandleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        heandleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupList() {
        if detailList != nil {
            isCreated = false
            textView.text = detailList?.title
            
            if let date = detailList?.notificationDate {
                isNotificate = true
                let dateComponents = calendar.getComponents(from: date)
                components = dateComponents
            }
            
        } else {
            isCreated = true
            detailList = storageManager.createEntity(entityName: "DetailList")
        }
    }
}


