//
//  Extension + UIView.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

extension UIView {
    static func loadFromNib<T: UIView>() -> T {
        guard let viewFromNib = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T else { fatalError("Fatal error \(T.self) does not exist") }
        return viewFromNib
    }
}


extension UIView {
    func drawCircle(centerPoint: CGPoint, radius: CGFloat, constant: CGFloat, startAngle: CGFloat, endAngle: CGFloat,fillColor: UIColor, strokeColor: UIColor) {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: centerPoint, radius: radius + constant, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.lineCap = .round
       
        self.layer.addSublayer(shapeLayer)
    }
}

