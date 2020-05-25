//
//  Extension + TextView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/23/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

extension UITextView {
    func shaking() {
        let animation = CABasicAnimation(keyPath: "position")
        
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 3, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 3, y: self.center.y))
        
        layer.add(animation, forKey: "")
    }
}

