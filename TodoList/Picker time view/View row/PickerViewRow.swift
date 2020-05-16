//
//  PickerViewRow.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class PickerViewRow: UIView {
    
    // MARK: - UI
    private let rowLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 37)
        label.textColor = UIColor(red: 0.631372549, green: 0.768627451, blue: 0.9921568627, alpha: 1)
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupConstraintsForLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public methods
    func setTextForRowLabel(text: String) {
        rowLabel.text = text
    }

    
    // MARK: - Constraints
    private func setupConstraintsForLabel() {
        addSubview(rowLabel)
        
        rowLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rowLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
