//
//  MenuTable.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


protocol MenuTableViewDelegate: class {
    func menuTableView(_ menuTableView: MenuTableView, didSelectedElement menuElement: Menu)
}

class MenuTableView: UITableView {
    
    // MARK: - External properties
    weak var menuDelegate: MenuTableViewDelegate?
    
    // MARK: - Private properties
    private let menu = Menu.allCases
    
    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupMenuTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    // MARK: - Private methods
    private func setupMenuTable() {
        register(MenuCell.self, forCellReuseIdentifier: MenuCell.reuseId)
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        separatorStyle = .none
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
        let menuElement = menu[indexPath.row]
        
        cell.menuImageView.image = menuElement.image
        cell.menuLabel.text = menuElement.description

        return cell
    }
}

// MARK: - UITableViewDelegate
extension MenuTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuElement = menu[indexPath.row]
        menuDelegate?.menuTableView(self, didSelectedElement: menuElement)
    }
}
