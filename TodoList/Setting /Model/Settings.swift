//
//  Settings.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/7/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation

enum Settings: CustomStringConvertible, CaseIterable {
    case mainScareen
    case language
    
    var description: String {
        switch self {
        case .mainScareen:
            return "Main screen"
        case .language:
            return "Language"
        }
    }
    
    var imagePath: String {
        switch self {
        case .mainScareen:
            return "homeScreen"
        case .language:
            return "language"
        }
    }
}
