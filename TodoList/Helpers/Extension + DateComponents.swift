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
    
    mutating func setTime(hour: Int?, minute: Int?) {
        self.minute = minute
        self.hour = hour
    }
    
    
    func hasDate() -> Bool {
        guard year != nil, month != nil, day != nil, hour != nil, minute != nil else { return false }
        return true
    }
    
    mutating func setComponentsDate(year: Int?, month: Int?, day: Int?) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    mutating func setComponentsTime(hour: Int?, minute: Int?) {
        self.hour = hour
        self.minute = minute
    }

}

