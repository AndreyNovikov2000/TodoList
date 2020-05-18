//
//  HeaderTextView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol HeaderTextViewDelegate: class {
    func headerTextViewDidCalendarButtonTapped()
    func headerTextViewdidAlarmButtonPressed()
    func headerTextViewDidimportanceButtonPressed(sender: UIButton)
    func headerxtViewDidSaveButtonpressed()
}

class HeaderTextView: UITextView {
    
    // MARK: External properties
    weak var myDelegate: HeaderTextViewDelegate?
    
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
    
    private let calendarButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(heandleCalendarButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "Calendar"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let alarmButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(heandleAralarmButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "Alarm"), for: .normal)
        return button
    }()
    
    private let importanceButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(heandleImportanceButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "lMarkOne"), for: .normal)
        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(heandleSaveButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "saveButton"), for: .normal)
        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return button
    }()


    
    // MARK: - Init
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupHeaderTextView()
        setupAccessaryView()
        setupButtonsForAccessaryView()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHeaderTextView()
        setupAccessaryView()
        setupButtonsForAccessaryView()
    }
    
    
    // MARK: Action
    @objc fileprivate func heandleCalendarButton() {
        myDelegate?.headerTextViewDidCalendarButtonTapped()
    }
    
    @objc fileprivate func heandleAralarmButtonPressed() {
        myDelegate?.headerTextViewdidAlarmButtonPressed()
    }
    
    @objc fileprivate func heandleImportanceButtonPressed() {
        myDelegate?.headerTextViewDidimportanceButtonPressed(sender: importanceButton)
    }
    
    @objc fileprivate func heandleSaveButtonPressed() {
        myDelegate?.headerxtViewDidSaveButtonpressed()
    }
    
    // MARK: - Private methods
    private func setupHeaderTextView() {
        showsVerticalScrollIndicator = false
        isScrollEnabled = false
        backgroundColor = .clear
        textColor = .black
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
        accessaryView.addSubview(importanceButton)
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
        
        // importanceButton constraints
        importanceButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        importanceButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        importanceButton.topAnchor.constraint(equalTo: accessaryView.topAnchor,constant: 5).isActive = true
        importanceButton.leadingAnchor.constraint(equalTo: alarmButton.leadingAnchor,constant: 40).isActive = true
        
        // save button constraints
        saveButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.topAnchor.constraint(equalTo: accessaryView.topAnchor,constant: 5).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: accessaryView.trailingAnchor,constant: -16).isActive = true
    }
}


extension HeaderTextView {
    func shaking() {
        let animation = CABasicAnimation(keyPath: "position")
        
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 3, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 3, y: self.center.y))
        
        layer.add(animation, forKey: "")
    }
}
