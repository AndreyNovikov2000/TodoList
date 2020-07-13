//
//  SettingsCell.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/7/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    static let reuseId = "SettingsCell"
    
    // MARK: - UI
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
     
        setup()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.layer.cornerRadius = 3
    }
    
    // MARK: - Public methods
    
    func set(with element: Settings) {
        titleLabel.text = element.description
        iconImageView.image = UIImage(named: element.imagePath)
    }
    
    // MARK: - Private metdods
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    private func setConstraints() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        // icon image view
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9).isActive = true
        
        // title label
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5).isActive = true
    }
}
