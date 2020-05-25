//
//  ColorCollestionView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/23/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ColorCollectionView: UICollectionView {
    
    // MARK: - Private properties
    let colors = ListColor.getColors()
    var selectedComplitionColor: ((UIColor) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        setupColorCollectionView()
        getFirstElementWhenCollectionViewIsLoaded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Private methods
    private func setupColorCollectionView() {
        register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.reuseId)
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
    }
    
    private func getFirstElementWhenCollectionViewIsLoaded() {
        // set default color when loaded
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
            if let firstColor = self.colors.first {
                self.selectedComplitionColor?(firstColor)
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension ColorCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseId, for: indexPath) as! ColorCollectionViewCell
        let color = colors[indexPath.item]
        
        cell.set(with: color)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ColorCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor = colors[indexPath.item]
        
        selectedComplitionColor?(selectedColor)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ColorCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

