//
//  ListAlertView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/25/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol ListAlertViewDelegate: class {
    func listAlertViewSaveButtonTapped(_ listAlertView: ListAlertView)
    func listAlertViewCancelButtonTapped(_ listAlertView: ListAlertView)
    func listAlertView(_ listAlertView: ListAlertView, didSelectedColor color: UIColor)
    func listAlertViewTitleTextFieldDidEndEditing(_ listAlertView: ListAlertView, titleListTextFeild: UITextField)
}

class ListAlertView: UIView {
    
    // MARK: - External properties
    weak var myDelegate: ListAlertViewDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var titeListTextField: UITextField!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: ListAlertButton!
    @IBOutlet weak var cancelButton: ListAlertButton!
    
    // MARK: - Private properties
    let colors = ListColor.getColors()
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupColorCollectionView()
        setupTitleListTextField()
    }
    
    // MARK: - IBAction
    @IBAction func saveButtonTapped() {
        myDelegate?.listAlertViewSaveButtonTapped(self)
    }
    
    @IBAction func cancelButtonPressed() {
        myDelegate?.listAlertViewCancelButtonTapped(self)
    }
    
    // MARK: - Private methods
    private func setupColorCollectionView() {
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseId)
        colorCollectionView.showsVerticalScrollIndicator = false
        colorCollectionView.showsHorizontalScrollIndicator = false
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.backgroundColor = .clear
    }
    
    private func setupTitleListTextField() {
        titeListTextField.borderStyle = .none
        titeListTextField.contentVerticalAlignment = .center
        titeListTextField.contentHorizontalAlignment = .center
        titeListTextField.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension ListAlertView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseId, for: indexPath) as! ColorCell
        let color = colors[indexPath.row]
        
        cell.set(with: color)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ListAlertView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colors[indexPath.row]
        
        myDelegate?.listAlertView(self, didSelectedColor: color)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListAlertView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


// MARK: - UITextFieldDelegate
extension ListAlertView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        myDelegate?.listAlertViewTitleTextFieldDidEndEditing(self, titleListTextFeild: textField)
    }
}
