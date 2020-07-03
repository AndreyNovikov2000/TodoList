//
//  ColorCell.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/25/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    // MARK: - External properties
    static let reuseId = "ColorCell"
    
    // MARK: - UI
    let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let borderColorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.clear.cgColor
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraintsForColorView()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorView.layer.cornerRadius = colorView.frame.height / 2
        borderColorView.layer.cornerRadius = borderColorView.frame.height / 2
    }
    
    // MARK: - Public methods
    func set(with color: UIColor) {
        colorView.backgroundColor = color
        borderColorView.layer.borderColor = color.cgColor
    }

    
    // MARK: - Private methods
    private func setupConstraintsForColorView() {
        addSubview(borderColorView)
        addSubview(colorView)
        
        
        // circle color view
        borderColorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        borderColorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        borderColorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        borderColorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        // colorView
        colorView.widthAnchor.constraint(equalToConstant: 33).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 33).isActive = true
        colorView.centerXAnchor.constraint(equalTo: borderColorView.centerXAnchor).isActive = true
        colorView.centerYAnchor.constraint(equalTo: borderColorView.centerYAnchor).isActive = true
    }
}
