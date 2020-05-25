//
//  Extension + UIVIewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/25/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

extension UIViewController {
    static func loadFromStoryboard<T: UIViewController>() -> T {
        return UIStoryboard(name: String(describing: T.self), bundle: nil).instantiateInitialViewController() as! T
    }
}
