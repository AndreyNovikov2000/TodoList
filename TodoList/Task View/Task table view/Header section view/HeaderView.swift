//
//  HeaderView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/17/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConstraintsForHeaderLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func setHeaderText(text: String) {
        headerLabel.text = text
    }
    
    // MARK: - Private methods
    private func setupConstraintsForHeaderLabel() {
        addSubview(headerLabel)
        
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    }
}
