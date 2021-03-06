//
//  PickerCalendaView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/14/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import KDCalendar

protocol PickerCalendarViewDelegate: class {
    func pickerCalendarView(_ pickerCalendarView: PickerCalendarView, didSelectedDate: Date)
    func pickerCalendarViewCancelButtonPressed(_ pickerCalendarView: PickerCalendarView)
    func picerCalendarViewClearButtonPressed(_ pickerCalendarView: PickerCalendarView)
}

class PickerCalendarView: UIView {
    
    // MARK: - External properies
    weak var myDelegate: PickerCalendarViewDelegate?
    
    // MARK: - IBOUtlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Private properties
    private let localizationSystem = LocalizationSystem.sharedInstance
    private let myStyle = CalendarView.Style()
    private let mainColor = UIColor(red: 0.4, green: 0.6509803922, blue: 1, alpha: 1)
    private var currentSelectedDate = Date()
    private var dateFormatter:  DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: LocalizationSystem.sharedInstance.getLanguage())
        df.dateFormat = "dd MMMM"
        return df
    }()
    
    // MARK: - Live cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCalendarView()
        setStyle()
        selectedDate.text = dateFormatter.string(from: currentSelectedDate)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.cornerRadius = 12
    }

    
    // MARK: - IBAction
    @IBAction func saveButtonPressed() {
        myDelegate?.pickerCalendarView(self, didSelectedDate: currentSelectedDate)
    }
    
    
    @IBAction func cancelButtonPressed() {
        myDelegate?.pickerCalendarViewCancelButtonPressed(self)
    }
    
    @IBAction func clearButtonPressed() {
        // TODO: LOCALIZED
        selectedDate.text = "Choise the date"
    }
    
    // MARK: - Private methods
    private func setupCalendarView() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.backgroundColor = .clear
       
        clearButtonPressed()
    }
    
    private func setStyle() {
        
        myStyle.cellShape = CalendarView.Style.CellShapeOptions.round
        
        // weekend
        myStyle.cellTextColorWeekend = .black
        myStyle.weekdaysFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        // header
        myStyle.headerTextColor = .black
        myStyle.headerHeight = 30
        
        // selected
        myStyle.cellSelectedBorderWidth = 1.5
        myStyle.cellSelectedBorderColor = mainColor
        myStyle.cellBorderColor = mainColor
        myStyle.cellSelectedTextColor = .white
        myStyle.cellSelectedColor = mainColor

        // today
        myStyle.cellTextColorToday = .white
        myStyle.cellColorToday = mainColor
        
        // default
        myStyle.cellTextColorDefault = .black
        myStyle.cellColorDefault = .clear
        
        myStyle.cellColorOutOfRange = .systemGray
        
        calendarView.style = myStyle
    }
    
    private func setHeaderDate(date: Date) -> String {
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
        dateFormatter.locale = Locale(identifier: LocalizationSystem.sharedInstance.getLanguage())
        dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}


// MARK: - CalendarViewDataSource
extension PickerCalendarView: CalendarViewDataSource {
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
        dateLabel.text = setHeaderDate(date: date)
        return ""
    }
}


// MARK: - CalendarViewDelegate
extension PickerCalendarView: CalendarViewDelegate {
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        calendarView.deselectDate(currentSelectedDate)
        currentSelectedDate = date
        selectedDate.text = dateFormatter.string(from: date)

        
        // style
        if currentSelectedDate == Date() {
            myStyle.cellTextColorToday = .white
            myStyle.cellColorToday = mainColor
        }
        
        myStyle.cellTextColorToday = .black
        myStyle.cellColorToday = .clear
        myStyle.cellColorOutOfRange = .systemGray
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        myStyle.cellColorOutOfRange = .systemGray
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        print("long")
    }
}
