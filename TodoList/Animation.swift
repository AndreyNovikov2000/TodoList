//
//  Animation.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

struct Animation {
    static func animateDegreeButton(for button: UIButton) {
        
        UIView.animate(withDuration: 0.17,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        })
        
        UIView.animate(withDuration: 0.17,
                       delay: 0.17,
                       options: .curveEaseOut,
                       animations: {
                        button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
    }
}
