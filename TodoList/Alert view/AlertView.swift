//
//  AlertView.swift
//  TodoList
//
//  Created by Andrey Novikov on 6/7/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol AlertViewDelegate: class {
    func alertViewDeleteButtonPressed(_ alertView: AlertView)
    func alertViewCancelButtonPressed(_ alertView: AlertView)
}

class AlertView: UIView {
    
    // MARK: - External properties
    weak var myDelegate: AlertViewDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var deleteButton: AlertButton!
    @IBOutlet weak var cancelButton: AlertButton!
    
    
    // MARK: - Live cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTitleLabel()
        setpDetailLabel()
        setupButtons()
    }
    
    
    // MARK: - IBActions
    @IBAction func deleteButtonPressed() {
        myDelegate?.alertViewDeleteButtonPressed(self)
    }
    
    @IBAction func cancelButtonPressed() {
        myDelegate?.alertViewCancelButtonPressed(self)
    }
    
    // MARK: - Public methods
    func setTitle(with text: String) {
        titleLabel.text = text
    }
    
    func setDetailTitle(with text: String) {
        detailLabel.text = text
    }
    
    // MARK: - Private methods
    private func setupTitleLabel() {
        // TODO: - Localize
        titleLabel.text = "Do you want to delete the list?"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .white
    }
    
    private func setpDetailLabel() {
        // TODO: - Localize
        detailLabel.text = "if you remove the list you will lose all tasks and notiofications"
        detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        detailLabel.numberOfLines = 3
        detailLabel.textColor = UIColor(red: 0.537254902, green: 0.5098039216, blue: 0.5764705882, alpha: 1)
    }
    
    private func setupButtons() {
        // TODO: - Localize
        deleteButton.titleLabel?.text = "Delete"
        deleteButton.backgroundColor = UIColor(red: 0.6705882353, green: 0.2862745098, blue: 0.2862745098, alpha: 1)
        
        // TODO: - Localize
        cancelButton.titleLabel?.text = "Cancel"
        cancelButton.backgroundColor = UIColor(red: 0.4156862745, green: 0.4078431373, blue: 0.4196078431, alpha: 1) 
    }
}
