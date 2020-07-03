//
//  TaskListCell.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/25/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol TaskListCellDelegate: class {
    func taskListCellCompliteButtonPressed(_ taskListCell: TaskListCell)
}

class TaskListCell: UITableViewCell {
    
    // MARK: - External properties
    weak var myDelegate:  TaskListCellDelegate?
    
    static let reuseId = "TaskListCell"
    
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
        view.backgroundColor = .white
        return view
    }()
    
    lazy var compliteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "MaskW"), for: .normal)
        button.addTarget(self, action: #selector(heanleCompliteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    // notification layer
    let alarmImageView: UIImageView = {
        let imageView =  UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "CalendarW")
        imageView.isHidden = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.alpha = 0.5
        label.isHidden = false
        return label
    }()
    
    lazy private var notificationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [alarmImageView, notificationLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    // MARK: - Private properties
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd MMM hh:mm"
        return df
    }()
    
    private var bottomNotificationConstraints: NSLayoutConstraint!
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
        
        setupConstraintsForContainerView()
        setupConstraintsForLineView()
        setupConstraintsForCompliteButton()
        setupConstraintsForTaskLabelAndNotificationLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Action
    @objc fileprivate func heanleCompliteButtonPressed() {
        compliteButton.setImage(UIImage(named: "MaskC"), for: .normal)
        myDelegate?.taskListCellCompliteButtonPressed(self)
    }

    
    // MARK: - Public methods
    func set(with detailList: DetailList, backgroundColor color: UIColor) {
        backgroundColor = color
        compliteButton.setImage(UIImage(named: "MaskW"), for: .normal)
        setupNotificationStackView(isNotificatite: detailList.isNotificate)
        taskLabel.text = detailList.title
        
        if let dateNotification = detailList.notificationDate, detailList.isNotificate {
            notificationLabel.text = dateFormatter.string(from: dateNotification)
        }
    }
    
    // MARK: - Private methods
    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func setupNotificationStackView(isNotificatite: Bool) {
        bottomNotificationConstraints.isActive = isNotificatite
        
        alarmImageView.isHidden = !isNotificatite
        notificationLabel.isHidden = !isNotificatite
    }
    
    // MARK: - Constraints
    private func setupConstraintsForContainerView() {
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
    
    private func setupConstraintsForCompliteButton() {
        containerView.addSubview(compliteButton)
        
        compliteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 18).isActive = true
        compliteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        compliteButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
        compliteButton.widthAnchor.constraint(equalToConstant: 23).isActive = true
    }

    private func setupConstraintsForTaskLabelAndNotificationLayer() {
        containerView.addSubview(taskLabel)
        containerView.addSubview(notificationStackView)
        
        // task label
        taskLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -18).isActive = true
        taskLabel.leadingAnchor.constraint(equalTo: compliteButton.trailingAnchor, constant: 18).isActive = true
        taskLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        taskLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 18).isActive = true
        
        // footer view
        bottomNotificationConstraints = notificationStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -18)
        bottomNotificationConstraints.isActive = true
        bottomNotificationConstraints.priority = UILayoutPriority(999)
        
        notificationStackView.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 5).isActive = true
        notificationStackView.leadingAnchor.constraint(equalTo: compliteButton.trailingAnchor, constant: 18).isActive = true
        notificationStackView.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
}
