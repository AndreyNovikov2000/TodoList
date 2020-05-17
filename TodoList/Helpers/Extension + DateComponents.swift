//
//  Extension + DateComponents.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/16/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation

extension DateComponents {
    mutating func setComponents(year: Int?, month: Int?, day: Int?) {
        self.year = year
        self.month = month
        self.day = day
    }
}
