//
//  ListMenu.swift
//  TodoList
//
//  Created by Andrey Novikov on 6/8/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

enum ListMenu: Int, MenuConvertable, CaseIterable {
    case listSubTask
    case deleteList

    // TODO: - Localize
    var description: String {
        switch self {
        case .listSubTask:
            return "New sub task"
        case .deleteList:
            return "Delete list"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .listSubTask:
            return UIImage(named: "Task")
        case .deleteList:
            return UIImage(named: "Delete")
        }
    }
}
