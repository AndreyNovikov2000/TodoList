//
//  CalendarView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import KDCalendar

class CalendarViewController: UIViewController {
    
    var selectedDate = [Date()]
    
    var calendarView: CalendarView = {
        let calendarView = CalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    var lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyleForCalendarView()
    
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        setupConstraintsForCalindarView()
        setupConstraintsForLineView()
    }
    
    
    // MARK: - Private methods
    private func setupStyleForCalendarView() {
        let myStyle = CalendarView.Style()

        calendarView.style = myStyle
        myStyle.cellShape = CalendarView.Style.CellShapeOptions.round
        myStyle.cellSelectedBorderWidth = 6

        //header
        myStyle.headerTextColor = .black
        myStyle.headerBackgroundColor = .red

        // today
//        myStyle.cellTextColorToday = .white
        myStyle.cellColorToday = UIColor(red: 1, green: 0.8196078431, blue: 0.4, alpha: 1)
        myStyle.cellBorderColor = UIColor(red: 1, green: 0.8196078431, blue: 0.4, alpha: 1)

        // selected
        myStyle.cellSelectedBorderColor = UIColor(red: 1, green: 0.8196078431, blue: 0.4, alpha: 1)
        myStyle.cellSelectedColor = UIColor(red: 1, green: 0.8196078431, blue: 0.4, alpha: 1)
        myStyle.cellSelectedTextColor = .black
        myStyle.cellColorDefault = .clear

        //weekend
        myStyle.cellTextColorWeekend = .black
        myStyle.cellTextColorDefault = .black

        //out of range
        myStyle.cellColorOutOfRange = UIColor(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)


        
        
        
        
////        CalendarView.Style.Default.cellShape = CalendarView.Style.CellShapeOptions.round
//
//        // Header
//        CalendarView.Style.Default.headerTextColor = .black
//        CalendarView.Style.Default.headerFont = UIFont.boldSystemFont(ofSize: 11)
//        CalendarView.Style.Default.showAdjacentDays = true
//
//
//        // Today
////        CalendarView.Style.Default.cellTextColorToday = .white
//        CalendarView.Style.Default.cellColorToday = UIColor(red: 1, green: 0.8196078431, blue: 0.4, alpha: 1)
//        CalendarView.Style.Default.cellBorderColor = UIColor(red: 1, green: 0.8196078431, blue: 0.4, alpha: 1)
//
//        // Selected
//        CalendarView.Style.Default.cellSelectedBorderColor = UIColor(red: 1, green: 0.8196078431, blue: 0.4, alpha: 1)
//        CalendarView.Style.Default.cellSelectedColor = UIColor(red: 1, green: 0.8196078431, blue: 0.4, alpha: 1)
//        CalendarView.Style.Default.cellSelectedTextColor = .black
//        CalendarView.Style.Default.cellColorDefault = .clear
//
//        // Weekend
//        CalendarView.Style.Default.cellTextColorWeekend = .black
//        CalendarView.Style.Default.cellTextColorDefault = .black
//
//        // Out of range
//         CalendarView.Style.Default.cellColorOutOfRange = UIColor(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    
    // MARK: - Constraints
    
    private func setupConstraintsForCalindarView() {
        view.addSubview(calendarView)
        
        calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        calendarView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant: 10).isActive = true
        calendarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    private func setupConstraintsForLineView() {
        view.addSubview(lineView)
        
        lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lineView.topAnchor.constraint(lessThanOrEqualTo: calendarView.bottomAnchor, constant: 1).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
}


// MARK: - CalendarViewDataSource
extension CalendarViewController: CalendarViewDataSource {
    func startDate() -> Date {
        let dateComponents = DateComponents()
        let today = Date()
        let theereMounthAgo = self.calendarView.calendar.date(byAdding: dateComponents, to: today)
        
        return theereMounthAgo ?? Date()
    }
    
    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = 24
        let today = Date()
        let threenMounth = self.calendarView.calendar.date(byAdding: dateComponents, to: today)
        
        return threenMounth ?? Date()
    }
    
    func headerString(_ date: Date) -> String? {
        
        let dateString: String
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        
        let currentPageYear = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: currentDate)
            
        if currentPageYear > currentYear {
            dateFormatter.dateFormat = "MMMM YYYY"
            dateString = dateFormatter.string(from: date)
            return dateString
        }
    

        dateFormatter.dateFormat = "MMMM"
        dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}


// MARK: - CalendarViewDelegate
extension CalendarViewController: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
    
    }
    
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        
    }
}

