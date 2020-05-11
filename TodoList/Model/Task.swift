//
//  Task.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

enum DegreeOfProtection: Int {
    case notImportant
    case important
    case veryImportant
    
    func getProtection() -> UIColor {
        switch self {
        case .notImportant:
            return UIColor(red: 0.38, green: 0.87, blue: 0.64, alpha: 1)
        case .important:
            return UIColor(red: 1, green: 0.91, blue: 0.38, alpha: 1)
        case .veryImportant:
            return UIColor(red: 0.96, green: 0.37, blue: 0.43, alpha: 1)
        }
    }
}

struct Task {
    let taskTitle: String
    let isComplite: Bool
    let isNitificate: Bool
    let dateNotification: Date
    let degreeOfProtection: DegreeOfProtection.RawValue
    let taskId: UUID
}

