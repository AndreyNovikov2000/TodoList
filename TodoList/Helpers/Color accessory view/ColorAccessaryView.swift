//
//  ColorsAccessaryTextView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/23/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol ColorTextViewDelegate: class {
    func colorTextView(_ colorTextView: ColorTextView, didSelectedColor color: UIColor)
}

class ColorTextView: UITextView {
    
    // MARK: - External properties
    var myDelegate: ColorTextViewDelegate?
    
    // MARK: - Private propertiest
    
    private let accessaryView: UIView = {
        let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let topLineView: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor(red: 0.1450980392, green: 0.1647058824, blue: 0.1921568627, alpha: 1)
        lineView.alpha = 0.1
        return lineView
    }()
    
    private let colorCollectionView: ColorCollectionView = {
        let collectionView = ColorCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupColorTextView()
        setupConstraintsForTopLine()
        setupConstraintsForColorCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupColorTextView() {
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        textColor = .white
        textContainerInset = UIEdgeInsets(top: 30, left: 16, bottom: 10, right: 16)
        font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        accessaryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        inputAccessoryView = accessaryView
        
        colorCollectionView.selectedComplitionColor = { [weak self] color in
            guard let self = self else { return }
            self.myDelegate?.colorTextView(self, didSelectedColor: color)
        }
    }
    
    
    // MARK: - Constraint
    private func setupConstraintsForTopLine() {
        accessaryView.addSubview(topLineView)
        
        topLineView.bottomAnchor.constraint(equalTo: accessaryView.topAnchor).isActive = true
        topLineView.leadingAnchor.constraint(equalTo: accessaryView.leadingAnchor).isActive = true
        topLineView.trailingAnchor.constraint(equalTo: accessaryView.trailingAnchor).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setupConstraintsForColorCollectionView() {
        accessaryView.addSubview(colorCollectionView)
        
        colorCollectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        colorCollectionView.trailingAnchor.constraint(equalTo: accessaryView.trailingAnchor, constant: -5).isActive = true
        colorCollectionView.leadingAnchor.constraint(equalTo: accessaryView.leadingAnchor, constant: 5).isActive = true
        colorCollectionView.centerYAnchor.constraint(equalTo: accessaryView.centerYAnchor).isActive = true
    }
}
