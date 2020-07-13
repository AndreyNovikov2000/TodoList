//
//  StoryTableView.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/13/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class StoryTableView: UITableView {

    var headerView = UIView()
    
    // MARKK: - Init
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupTable() {
       
        tableHeaderView = headerView
        tableFooterView = UIView()
        separatorStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        dragInteractionEnabled = true
    }
}
