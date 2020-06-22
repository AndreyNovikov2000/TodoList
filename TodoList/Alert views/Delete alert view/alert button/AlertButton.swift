//
//  AlertButton.swift
//  TodoList
//
//  Created by Andrey Novikov on 6/7/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class AlertButton: UIButton {

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupButton()
    }
    
    // MARK: - Live cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
    
    // MARK: - Private methods
    private func setupButton() {
        titleLabel?.textColor = UIColor(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
}
