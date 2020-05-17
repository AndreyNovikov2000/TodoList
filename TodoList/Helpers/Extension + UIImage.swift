//
//  Extension + UIImage.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/14/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

extension UIImage {
    class func getGegreeOfProtection(_ degree: Int16) -> UIImage? {
        switch degree {
        case 0:
            return UIImage(named: "lMarkOne")
        case 1:
            return UIImage(named: "lMarkTwo")
        case 2:
            return UIImage(named: "lMarkThree")
        default:
            return UIImage(named: "")
        }
    }
}
