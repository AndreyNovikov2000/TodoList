//
//  FooterView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    // MARK: - Public properties
    let footerButton = UIButton()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupFooterButton()
        setupConstraintsForFotterButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupFooterButton() {
        // FIXME: - localize
        let title = "Добавить подзадачу..."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        footerButton.setAttributedTitle(NSAttributedString(string: title, attributes: attributes), for: .normal)
        footerButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraintsForFotterButton() {
        addSubview(footerButton)
        
        footerButton.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        footerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35).isActive = true
        footerButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        footerButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
}
