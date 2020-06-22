//
//  StoryCollectionView.swift
//  TodoList
//
//  Created by Andrey Novikov on 6/15/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class StoryCollectionView: UICollectionView {

    
    var progress: [CGFloat] = [0.3, 0.5, 0.7, 0.1, 0.8, 0.5, 0.22, 0.123, 0.345, 0.345, 0.1, 1]
    
   // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupCollectionView() {
        delegate = self
        dataSource = self
        register(StoryCell.self, forCellWithReuseIdentifier: StoryCell.reuseId)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        contentInset = UIEdgeInsets(top: 0, left: Constants.collectionViewInsets.left, bottom: 0, right: Constants.collectionViewInsets.right)
        
        progress.insert(0, at: 0)
    }
}


// MARK: - UICollectionViewDataSource
extension StoryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return progress.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: StoryCell.reuseId, for: indexPath) as! StoryCell
        cell.backgroundColor = .white
        let pr = progress[indexPath.row]
        cell.set(indexPath: pr)
        
        if indexPath.row == 0 {
            cell.backgroundColor = .red
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension StoryCollectionView: UICollectionViewDelegate {
}


// MARK: - UICollectionViewDelegateFlowLayout
extension StoryCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.storyCollectionViewContentSize.width, height: Constants.storyCollectionViewContentSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.storyCollectionViewMinimumLineSpacing
    }
}
