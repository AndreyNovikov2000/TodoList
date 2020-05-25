//
//  Menu.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

enum Menu: Int, CustomStringConvertible, CaseIterable {
    case task
    case list
    
    // TODO: - Localized
    var description: String {
        switch self {
        case .task:
            return NSLocalizedString("Task", comment: "")
        case .list:
            return NSLocalizedString("List", comment: "")
        }
    }
    
    var image: UIImage? {
        switch self {
        case .task:
            return UIImage(named: "Task")
        case .list:
            return UIImage(named: "List")
        }
    }
}
