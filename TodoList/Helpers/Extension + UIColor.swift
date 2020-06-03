//
//  Extension + UIColor.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//


import UIKit

extension UIColor {
    class func color(withData data: Data?) -> UIColor? {
        guard let data = data else { return .white }
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
    }
    
    func encode() -> Data {
        return try! NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
}
