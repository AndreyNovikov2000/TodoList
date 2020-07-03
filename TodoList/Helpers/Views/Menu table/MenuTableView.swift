//
//  MenuTable.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol MenuConvertable {
    var description: String { get }
    var image: UIImage? { get }
}

class MenuTableView<T: MenuConvertable>: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Public properties
    var selectedComplitionItem: ((T) -> Void)?
    var menu = [T]()
    
    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupMenuTable()
    }
    
    convenience init(object: [T]) {
        self.init(frame: .zero, style: .plain)
        self.menu = object
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
    }
    
    // MARK: - Private methods
    private func setupMenuTable() {
        register(MenuCell.self, forCellReuseIdentifier: MenuCell.reuseId)
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        clipsToBounds = true
        separatorStyle = .none
        dataSource = self
        delegate = self
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseId, for: indexPath) as! MenuCell
        let menuElement = menu[indexPath.row]
        
        cell.imageView?.image = menuElement.image
        cell.menuLabel.text = menuElement.description
        
        return cell
    }
    
    // MARK: - UItableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.menuTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuElement = menu[indexPath.row]
        selectedComplitionItem?(menuElement)
    }
}
