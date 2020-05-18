//
//  MenuTable.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

enum Menu: Int, CustomStringConvertible, CaseIterable {
    // TODO: - Localized
    var description: String {
        switch self {
        case .task:
            return NSLocalizedString("Task", comment: "")
        case .list:
            return NSLocalizedString("List", comment: "")
        }
    }
    
    var image: UIImage? {
        switch self {
        case .task:
            return UIImage(named: "task")
        case .list:
            return UIImage(named: "list")
        }
    }
    
    case task
    case list
}

class MenuTableView: UITableView {

    
    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupMenuTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupMenuTable() {
        register(MenuCell.self, forCellReuseIdentifier: MenuCell.reuseId)
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
    }
}


// MARK: - UITableViewDataSource
extension MenuTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Menu.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseId, for: indexPath) as! MenuCell
        let menuElement = Menu(rawValue: indexPath.row)
        
        cell.textLabel?.text = menuElement?.description

        return cell
    }
}

// MARK: - UITableViewDelegate
extension MenuTableView: UITableViewDelegate {
    
}
