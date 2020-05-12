//
//  SubCell.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/11/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol SubTaskCellDelegate: class {
    func subTaskCellDidComplite(subTaskCell: SubTaskCell)
    func subTaskCellDidRemove(subTaskCell: SubTaskCell)
    func subTaskCellDidEndEditing(subTaskCell: SubTaskCell)
}

class SubTaskCell: UITableViewCell {

    // MARK: - External properties
    weak var myDelegate: SubTaskCellDelegate?
    
    static let reuseId = "SubTaskCell"
    
    @IBOutlet weak var subTaskTextField: UITextField!
    @IBOutlet weak var compliteButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    // MARK: - Live cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTaskTitleTextField()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    }
    
    // MARK: - IBAction
   
    @IBAction func compliteButtonTapped() {
        myDelegate?.subTaskCellDidComplite(subTaskCell: self)
    }
    
    @IBAction func deleteButtonTapped() {
        myDelegate?.subTaskCellDidRemove(subTaskCell: self)
    }
    // MARK: - Public methods
    func set(subTask: SubTask?) {
        guard let subTask = subTask else { return }
        
        let imageForCompliteButton = subTask.isComplite ? UIImage(named: "MaskC") : UIImage(named: "MaskU")

        compliteButton.setImage(imageForCompliteButton, for: .normal)
        subTaskTextField.text = subTask.subTaskTitle
    }
    
    
    // MARK: - Private methods
    private func setupTaskTitleTextField() {
        // FIXME: - LOCALIZED
        let placeholder = "Новая подзадача"
        let myFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font: myFont]
        
        subTaskTextField.attributedPlaceholder =  NSAttributedString(string: placeholder, attributes: attributes)
        subTaskTextField.backgroundColor = .clear
        subTaskTextField.clearButtonMode = .whileEditing
        subTaskTextField.contentHorizontalAlignment = .center
        subTaskTextField.contentVerticalAlignment = .center
        subTaskTextField.borderStyle = .roundedRect
        subTaskTextField.borderStyle = .none
        subTaskTextField.delegate = self
    }
    
}

// MARK: - UITextFieldDelegate
extension SubTaskCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        myDelegate?.subTaskCellDidEndEditing(subTaskCell: self)
    }
}
