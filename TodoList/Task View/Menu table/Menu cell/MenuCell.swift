//
//  MenuCell.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    static let reuseId = "MenuCell"
    
    // MARK: - UI
    let menuImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        return image
    }()
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0, green: 0.405741334, blue: 1, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.631421864, green: 0.6276709437, blue: 0.6343069077, alpha: 1)
        return view
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupMenuCell()
        setupConstraintsForFirstLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private methods
    private func setupMenuCell() {
        selectionStyle = .none
    }
    
    // MARK: - Constraints
    private func setupConstraintsForFirstLayer() {
        addSubview(menuImageView)
        addSubview(menuLabel)
        addSubview(lineView)
        
        // menuImageView
        menuImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19).isActive = true
        menuImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        menuImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        menuImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        // menuLabel
        menuLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 12).isActive = true
        menuLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        menuLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        // lineView
        lineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 1).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
