//
//  ListTextView.swift
//  TodoList
//
//  Created by Andrey Novikov on 6/1/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol ListTextViewDelegate: class {
    func listTextViewCalendarButtonPressed(_ listTextView: ListTextView)
    func listTextViewAlarmButtonPressed(_ listTextView: ListTextView)
    func listTextViewSaveButtonPressed(_ listTextView: ListTextView)
}

class ListTextView: UITextView {
    
    // MARK: - External properties
    weak var myDelegate: ListTextViewDelegate?
    
    // MARK: UI
    
    // first layer
    private let accessaryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    // second layer
    private let topLineView: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor(red: 0.1450980392, green: 0.1647058824, blue: 0.1921568627, alpha: 1)
        lineView.alpha = 0.1
        return lineView
    }()
    
    lazy private var calendarButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(heandleCalendarButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "Calendar"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
   lazy  private var alarmButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(heandleAralarmButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "Alarm"), for: .normal)
        return button
    }()
    
    lazy private var saveButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(heandleSaveButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "saveButton"), for: .normal)
        return button
    }()

    
    
    // MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupTextView()
        setupAccessaryView()
        setupButtonsForAccessaryView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Action
    @objc fileprivate func heandleCalendarButton() {
        myDelegate?.listTextViewCalendarButtonPressed(self)
    }
    
    @objc fileprivate func heandleAralarmButtonPressed() {
        myDelegate?.listTextViewAlarmButtonPressed(self)
    }
    
    @objc fileprivate func heandleSaveButtonPressed() {
        myDelegate?.listTextViewSaveButtonPressed(self)
    }
    
    // MARK: - Private methods
    private func setupTextView() {
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        textColor = .white
        textContainerInset = UIEdgeInsets(top: 30, left: 16, bottom: 10, right: 16)
        font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    private func setupAccessaryView() {
        accessaryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        inputAccessoryView = accessaryView
        
        accessaryView.addSubview(topLineView)
        
        topLineView.bottomAnchor.constraint(equalTo: accessaryView.topAnchor).isActive = true
        topLineView.leadingAnchor.constraint(equalTo: accessaryView.leadingAnchor).isActive = true
        topLineView.trailingAnchor.constraint(equalTo: accessaryView.trailingAnchor).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setupButtonsForAccessaryView() {
        
        accessaryView.addSubview(calendarButton)
        accessaryView.addSubview(alarmButton)
        accessaryView.addSubview(saveButton)
        
        // calendar constraints
        calendarButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        calendarButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        calendarButton.topAnchor.constraint(equalTo: accessaryView.topAnchor,constant: 5).isActive = true
        calendarButton.leadingAnchor.constraint(equalTo: accessaryView.leadingAnchor,constant: 16).isActive = true
        
        // alarm constraints
        alarmButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        alarmButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        alarmButton.topAnchor.constraint(equalTo: accessaryView.topAnchor,constant: 5).isActive = true
        alarmButton.leadingAnchor.constraint(equalTo: calendarButton.leadingAnchor,constant: 40).isActive = true

        
        // save button constraints
        saveButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.topAnchor.constraint(equalTo: accessaryView.topAnchor,constant: 5).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: accessaryView.trailingAnchor,constant: -16).isActive = true
    }
}
