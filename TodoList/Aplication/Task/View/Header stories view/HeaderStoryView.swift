//
//  HeaderStoryView.swift
//  TodoList
//
//  Created by Andrey Novikov on 6/15/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class HeaderStoryView: UIView {
    
    // MARK: - UI
    let storyCollectionView: StoryCollectionView = {
        let collectionView = StoryCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Live cycle
    override func draw(_ rect: CGRect) {
        setupConstraintsForStoryCollectionView()
    }
    
    // MARK: - Private methods
    private func setupConstraintsForStoryCollectionView() {
        addSubview(storyCollectionView)
        storyCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        storyCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        storyCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        storyCollectionView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
    }
}
