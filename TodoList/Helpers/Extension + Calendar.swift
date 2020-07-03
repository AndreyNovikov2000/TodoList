//
//  Extension + Calendar.swift
//  TodoList
//
//  Created by Andrey Novikov on 6/9/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation

extension Calendar {
    func getComponents(from date: Date) -> DateComponents {
        var components = DateComponents()
        
        let year = component(.year, from: date)
        let day = component(.day, from: date)
        let month = component(.month, from: date)
        let minute = component(.minute, from: date)
        let second = component(.second, from: date)
        
        components.year = year
        components.month = month
        components.day = day
        components.minute = minute
        components.second = second
        
        return components
    }
}

extension Calendar {
    func replaceDate(fromDate: Date?, byAdding day: Int) -> Date? {
        guard let fromDate = fromDate else { return Date() }
        let calendar = Calendar.current
        var componets = DateComponents()
        componets.day = day
        
        return calendar.date(byAdding: componets, to: fromDate)
    }
}

