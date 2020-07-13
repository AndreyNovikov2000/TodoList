//
//  TaskTableView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


class TaskTableView: UITableView {
    
    // MARK: - Public properties
    let footerView = FooterListView()
    let headerView = HeaderStoryView()
    
    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)
        
        setupTableView()
        setupHeaderView()
        setupFooterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private methods
    private func setupTableView() {
        register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseId)
        separatorStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        dragInteractionEnabled = true
    }
    
    private func setupFooterView() {
        footerView.backgroundColor = .clear
        footerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
        // TODO: - Localize
        footerView.setFooterText(text: "Lists")
        tableFooterView = footerView
    }
    
    private func setupHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        tableHeaderView = headerView
    }
}
