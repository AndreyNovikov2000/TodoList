//
//  TitleView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol TitleViewDelegate {
    func calendarButtomPressed()
}

class TitleView: UIView {
    
    var titleViewDelegate: TitleViewDelegate?
    
    override var intrinsicContentSize: CGSize { return UIView.layoutFittingExpandedSize }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "titleIcon")
        return imageView
    }()
    
    let calendarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "titleIcon"), for: .normal)
        button.addTarget(self, action: #selector(heandleCalendarButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraintsForCalendarButton()
        setupConstraintsForIconImageView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc fileprivate func heandleCalendarButtonPressed() {
        titleViewDelegate?.calendarButtomPressed()
    }
    
    // MARK: - Constraints
    private func setupConstraintsForIconImageView() {
        addSubview(iconImageView)
        
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setupConstraintsForCalendarButton() {
        addSubview(calendarButton)
        
        calendarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        calendarButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        calendarButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        calendarButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
}


