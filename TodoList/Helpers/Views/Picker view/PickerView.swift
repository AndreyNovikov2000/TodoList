//
//  PickerView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/12/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol PickerViewDelegate: class {
    func pickerView(_ pickerView: PickerView, saveButtonPressedWith dateComponents: DateComponents)
    func pickerViewCancelButtonPressed()
    func pickerViewClearButtonPressed(_ pickerView: PickerView)
}

class PickerView: UIView {
    
    // MARK: - External properties
    weak var myDelegate: PickerViewDelegate?
    
    // MARK: IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var hourPickerView: UIPickerView!
    @IBOutlet weak var minutesPickerView: UIPickerView!
    @IBOutlet weak var clearButton: UIButton!
    
    private let minutes = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09",
                           "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
                           "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
                           "30", "31", "32", "33", "34", "35", "36", "37", "38", "39",
                           "40", "41", "42", "43", "44", "45", "46", "47", "48", "49",
                           "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    
    private let hours = ["00", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11",
                         "12", "13", "14", "15", "16", "17", "18", "19", "20","21", "22", "23"]
    
    private var hour: Int?
    private var minute: Int?
    
    private let pickerViewRow = PickerViewRow()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPickers()
        
        containerView.layer.cornerRadius = 13
    }
    
    // MARK: - Action
    @IBAction func saveButtonTapped() {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        
        myDelegate?.pickerView(self, saveButtonPressedWith: components)
    }
    
    @IBAction func cancelButtonTapped() {
        myDelegate?.pickerViewCancelButtonPressed()
    }
    
    @IBAction func clearButtonTapped() {
        myDelegate?.pickerViewClearButtonPressed(self)
    }
    
    // MARK: - Private methods
    private func setupPickers() {
        hourPickerView.delegate = self
        hourPickerView.dataSource = self
        minutesPickerView.dataSource = self
        minutesPickerView.delegate = self
        
        hourPickerView.selectRow(hours.count / 2 , inComponent: 0, animated: false)
        minutesPickerView.selectRow(minutes.count / 2 , inComponent: 0, animated: false)
        
        pickerView(hourPickerView, didSelectRow: hours.count / 2, inComponent: 0)
        pickerView(minutesPickerView, didSelectRow: minutes.count / 2, inComponent: 0)
    }
}


// MARK: - UIPickerViewDataSource
extension PickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == hourPickerView ? hours.count : minutes.count
    }
}

// MARK: - UIPickerViewDelegate
extension PickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(minutes[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let viewRow = PickerViewRow()
        let rowText = pickerView == hourPickerView ? hours[row] : minutes[row]
        
        viewRow.setTextForRowLabel(text: rowText)
        
        return viewRow
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 70
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hourPickerView {
            hour = Int(hours[row])
        } else {
            minute = Int(minutes[row])
        }
    }
}

