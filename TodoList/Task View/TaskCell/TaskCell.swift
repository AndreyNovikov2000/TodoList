//
//  TaskCell.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/14/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol TaskCellDelegate: class {
    func taskCellDidComplite(taskCell: TaskCell)
    func taskCellDegreeOfProtectionButtonPressed(taskCell: TaskCell)
}

class TaskCell: UITableViewCell {
    
    // MARK: - Exretnal properties
    weak var myDelegate: TaskCellDelegate?
    
    static let reuseId = "TaskCell"
    
    // MARK: - UI
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.1450980392, green: 0.1647058824, blue: 0.1921568627, alpha: 0.5048052226)
        return view
    }()
    
    lazy var compliteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "MaskU"), for: .normal)
        button.addTarget(self, action: #selector(heanleCompliteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var degreeOfProtectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "lMarkOne"), for: .normal)
        button.addTarget(self, action: #selector(heandleDegreeOfProtectionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.1450980392, green: 0.1647058824, blue: 0.1921568627, alpha: 1)
        return label
    }()
    
    // notification layer
    let alarmImageView: UIImageView = {
        let imageView =  UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Alarm")
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "label.textColor"
        label.textColor = UIColor(red: 0.1450980392, green: 0.1647058824, blue: 0.1921568627, alpha: 0.4)
        return label
    }()
    
    // MARK: - Private properties
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd MMM hh:mm"
        return df
    }()
    
    private var alarmImageViewBottomConstraints: NSLayoutConstraint!
  

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraintsForContainerView()
        setupConstraintsForLineView()
        setupConstraintsForCompliteButton()
        setupConstraintsForDegreeOfProtectionButton()
        setupConstraintsForTaskLabelAndNotificationLayer()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public methods
    func set(task: Task) {
        taskLabel.text = task.taskTitle
        
        degreeOfProtectionButton.setImage(UIImage.getGegreeOfProtection(task.degreeOfProtection) , for: .normal)
        
        
        if let dateNotification = task.dateNotification ,task.isNotificate {
            notificationLabel.text = dateFormatter.string(from: dateNotification)
        } else {
            alarmImageViewBottomConstraints.constant = 5
            alarmImageView.isHidden = true
            notificationLabel.isHidden = true
        }
    }
    
    // MARK: - Action
    @objc fileprivate func heandleDegreeOfProtectionButtonPressed() {
        myDelegate?.taskCellDegreeOfProtectionButtonPressed(taskCell: self)
    }
    
    @objc fileprivate func heanleCompliteButtonPressed() {
         myDelegate?.taskCellDidComplite(taskCell: self)
    }
    
    // MARK: - Private methods
    
    // MARK: - Constraints
    func setupConstraintsForContainerView() {
        addSubview(containerView)
        
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setupConstraintsForLineView() {
        containerView.addSubview(lineView)
        
        lineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 60).isActive = true
        lineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -0.5).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    func setupConstraintsForCompliteButton() {
        containerView.addSubview(compliteButton)
        
        compliteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18).isActive = true
        compliteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        compliteButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        compliteButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func setupConstraintsForDegreeOfProtectionButton() {
        containerView.addSubview(degreeOfProtectionButton)
        
        degreeOfProtectionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        degreeOfProtectionButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        degreeOfProtectionButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        degreeOfProtectionButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func setupConstraintsForTaskLabelAndNotificationLayer() {
        containerView.addSubview(taskLabel)
        containerView.addSubview(alarmImageView)
        containerView.addSubview(notificationLabel)
        
        // task label
        taskLabel.leadingAnchor.constraint(equalTo: compliteButton.trailingAnchor, constant: 18).isActive = true
        taskLabel.trailingAnchor.constraint(equalTo: degreeOfProtectionButton.leadingAnchor, constant: -16).isActive = true
        taskLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 19).isActive = true
        taskLabel.bottomAnchor.constraint(equalTo: alarmImageView.topAnchor, constant: -6).isActive = true
        
        // alarm image view
        alarmImageViewBottomConstraints = alarmImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
        alarmImageViewBottomConstraints.isActive = true
        
        alarmImageView.leadingAnchor.constraint(equalTo: compliteButton.trailingAnchor, constant: 18).isActive = true
        alarmImageView.heightAnchor.constraint(equalToConstant: 17).isActive = true
        alarmImageView.widthAnchor.constraint(equalToConstant: 17).isActive = true
        
        // notification label
        notificationLabel.centerYAnchor.constraint(equalTo: alarmImageView.centerYAnchor).isActive = true
        notificationLabel.leadingAnchor.constraint(equalTo: alarmImageView.trailingAnchor, constant: 7).isActive = true
    }
}
