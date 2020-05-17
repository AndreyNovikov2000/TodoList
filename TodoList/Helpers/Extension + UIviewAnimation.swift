//
//  Extension + UIviewAnimation.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/16/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


extension UIView {
    func animateDegreeButton(for button: UIButton) {
        
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

extension UIView {
    func visualEffectAnimateIn(visualEffectView: UIVisualEffectView, compliteAnimation: (() -> Void)?) {
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            visualEffectView.alpha = 1
            
            self.alpha = 1
            self.transform = CGAffineTransform.identity
            
        }) { _ in
            compliteAnimation?()
        }
    }
    
    func visualEffectViewAnimateOut(visualEffectView: UIVisualEffectView, compliteAnimation: ((() -> Void)?)) {
        
        UIView.animate(withDuration: 0.4, animations: {
            visualEffectView.alpha = 0
            
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            
        }) { _ in
            compliteAnimation?()
        }
    }
}
