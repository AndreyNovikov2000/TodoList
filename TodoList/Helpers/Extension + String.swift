//
//  Extension + String.swift
//  TodoList
//
//  Created by Andrey Novikov on 6/22/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation

extension String {
    static func getDay(with date: Date) -> String {
        let today = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1

        let yesterdayDate = calendar.date(byAdding: dateComponents, to: today)
        
        let todayDay = calendar.component(.day, from: today)
        let yesterdayDay = calendar.component(.day, from: yesterdayDate!)
        let fromDay = calendar.component(.day, from: date)
        
        if todayDay == fromDay {
            return "today"
        } else if yesterdayDay == fromDay {
            return "tomorrow"
        }
        
        return "later"
    }
}
