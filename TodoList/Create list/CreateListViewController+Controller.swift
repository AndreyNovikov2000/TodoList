//
//  CreateListViewController+Controller.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/4/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


// MARK: - UIAdaptivePresentationControllerDelegate
extension CreateListViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        saveTask()
    }
}
