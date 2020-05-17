//
//  Extension + UIButton.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/17/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

extension UIButton {
    
    enum DegreeProtection: Int16 {
        case notImportant
        case important
        case veryImportant
    }
    
    func getDegreeProtection(for button: UIButton) -> DegreeProtection.RawValue {
        switch button.image(for: .normal) {
        case UIImage(named: "lMarkOne"):
            button.setImage(UIImage(named: "lMarkTwo"), for: .normal)
           return DegreeProtection.important.rawValue
        case UIImage(named: "lMarkTwo"):
            button.setImage(UIImage(named: "lMarkThree"), for: .normal)
            return DegreeProtection.veryImportant.rawValue
        case UIImage(named: "lMarkThree"):
            button.setImage(UIImage(named: "lMarkOne"), for: .normal)
            return DegreeProtection.notImportant.rawValue
        default:
            break
        }
        
        return DegreeProtection.notImportant.rawValue
    }
}
