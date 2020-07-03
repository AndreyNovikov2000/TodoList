//
//  ListViewController+Views.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


// MARK: - HeaderListViewDelegate
extension ListViewController: HeaderListViewDelegate {
    func headerListViewDidEditingButtonTapped(_ headerListView: HeaderListView) {
        setupVisualEffectView()
        setupListAlertView()
        animateIn(on: listAlertView)
        
        if let text = list?.title{
            listAlertView.titleListTextField.text = text
        }
        listAlertView.titleListTextField.becomeFirstResponder()
    }
}


// MARK: - ListAlertViewDelegate
extension ListViewController: ListAlertViewDelegate {
    func listAlertViewSaveButtonTapped(_ listAlertView: ListAlertView) {
        animateOut(on: listAlertView) { [weak self] in
            self?.listAlertView.removeFromSuperview()
            self?.removeVisualEffectView()
            self?.storageManager.save()
        }
    }
    
    func listAlertViewCancelButtonTapped(_ listAlertView: ListAlertView) {
        animateOut(on: listAlertView) { [weak self] in
            self?.listAlertView.removeFromSuperview()
            self?.removeVisualEffectView()
        }
    }
    
    func listAlertView(_ listAlertView: ListAlertView, didSelectedColor color: UIColor) {
        table.backgroundColor = color
        view.backgroundColor = color
        defaulListtColor = color
        table.reloadData()
    }
    
    func listAlertView(_ listAlertView: ListAlertView, textFieldDidEndEditing textField: UITextField) {
        if let text = textField.text {
            headerListView.setListTitleLabel(with: text)
            list?.title = text
        }
    }
}


// MARK: - AlertViewDelegate
extension ListViewController: AlertViewDelegate {
    func alertViewDeleteButtonPressed(_ alertView: AlertView) {
        guard let list = list else { return }
        animateOut(on: alertView) { [weak self] in
            self?.menuAnimateOut()
            self?.alertView.removeFromSuperview()
            self?.dismiss(animated: true, completion: nil)
        }
        
        storageManager.delete(object: list)
        storageManager.save()
        dismissComplition?()
    }
    
    func alertViewCancelButtonPressed(_ alertView: AlertView) {
        animateOut(on: alertView) { [weak self] in
            self?.menuAnimateOut()
            self?.alertView.removeFromSuperview()
        }
    }
}
