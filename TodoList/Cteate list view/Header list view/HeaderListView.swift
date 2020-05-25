//
//  HeaderListView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/25/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol HeaderListViewDelegate: class {
    func headerListViewDidEditingButtonTapped(_ headerListView: HeaderListView)
}

class HeaderListView: UIView {
    
    // MARK: - External properties
    weak var myDelegate: HeaderListViewDelegate?
    
    // MARK: - Private properties
    
    // first layer
    private  let listTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "List title"
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = .white
        return label
    }()
    
    private let listCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 tasks"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    
    lazy private var editingListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(headnleEditingListButtonPressed), for: .touchUpInside)
        button.setBackgroundImage(UIImage(named: "editingButton"), for: .normal)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHederView()
        setupConstraintsForFirstLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    @objc fileprivate func headnleEditingListButtonPressed() {
        myDelegate?.headerListViewDidEditingButtonTapped(self)
    }
    
    // MARK: - Public methods
    func setListTitleLabel(with title: String) {
        listTitleLabel.text = title
    }
    
    func setListCountLabel(with title: String) {
        listCountLabel.text = title
    }
    
    // MARK: - Private methods
    private func setupHederView() {
        backgroundColor = .clear
    }
    
    private func setupConstraintsForFirstLayer() {
        addSubview(listTitleLabel)
        addSubview(listCountLabel)
        addSubview(editingListButton)
        
        // listTitleLabel
        listTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
        listTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        listTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56).isActive = true
        
        // listCounLabel
        listCountLabel.topAnchor.constraint(equalTo: listTitleLabel.bottomAnchor, constant: 5).isActive = true
        listCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        listCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56).isActive = true
        
        // editingListButton
        editingListButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        editingListButton.topAnchor.constraint(equalTo: topAnchor, constant: 35).isActive = true
        editingListButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        editingListButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
