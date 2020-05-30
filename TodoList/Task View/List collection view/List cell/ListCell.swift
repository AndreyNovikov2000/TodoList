//
//  ListCell.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/18/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {
    static let reuseId = "ListCell"
    
    // MARK: - UI
    
    // first layer
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.3803921569, green: 0.8705882353, blue: 0.6431372549, alpha: 1)
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    // second layer
    private let listNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    
    private let listCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        setupConstraintsForContainerView()
        setupConstraintsForSecondLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        containerView.layer.cornerRadius = 10
    }
    
    // MARK: - Public methods
    func set(list: List) {
        listNameLabel.text = list.title
        // TODO: - Localize
        listCounterLabel.text = "\(String(describing: list.detailLists?.count)) tasks"
    }
    
    func setBg(color: UIColor) {
        containerView.backgroundColor = color
        listNameLabel.text = "personal"
        listCounterLabel.text = "12 tasks"
    }
    
    // MARK: - Constraints
    private func setupConstraintsForContainerView() {
        addSubview(containerView)
        
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func setupConstraintsForSecondLayer() {
        containerView.addSubview(listNameLabel)
        containerView.addSubview(listCounterLabel)

        listNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        listNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        listNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true

        listCounterLabel.topAnchor.constraint(equalTo: listNameLabel.bottomAnchor, constant: 4).isActive = true
        listCounterLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        listCounterLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
}
