//
//  Constants.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

struct Constants {
    static let storiesCollectionViewCircleCellSize: CGFloat = 58
    static let storiesCollectionViewFullCircleCellSize: CGFloat = Constants.storiesCollectionViewCircleCellSize + 15
    static let storiesCollectionViewInsetItem: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
    static let storiesCollectionViewMinimumLineSpacing: CGFloat = 20
    static let taskCellPadding = UIEdgeInsets(top: 20, left: 18, bottom: 20, right: 20)
    static let paddingBetweenTableViewAndScrollView = UIEdgeInsets(top: 25, left: 0, bottom: 15, right: 0)
}



struct AppConstrants {
    static let headerColorsForTaskTableViewHeader: [UIColor] = [UIColor(red: 0.1021237299, green: 0.597595036, blue: 0.8779979348, alpha: 1),
                                                                UIColor(red: 0, green: 0.3936163485, blue: 0.5803127289, alpha: 1),
                                                                UIColor(red: 0.8117647059, green: 0.8235294118, blue: 0.8039215686, alpha: 1),
                                                                UIColor(red: 0.8117647059, green: 0.8235294118, blue: 0.8039215686, alpha: 1)]
}


