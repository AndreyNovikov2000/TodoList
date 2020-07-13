//
//  Constants.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

struct Constants {
    
    // Screen
    static let screenBounds: CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    
    static let collectionViewInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    // list cillection view
    static let listCollectionViewContentSize = CGSize(width: 220, height: 80)
    static let listCollectionViewMinimumLineSpacing: CGFloat = 5
    
    // story collection view
    static let storyCollectionViewContentSize = CGSize(width: 60, height: 60)
    static let storyCollectionViewMinimumLineSpacing: CGFloat = 20
    
    // menu table view
    static let menuTableViewCellHeight: CGFloat = 60
    
    
}

