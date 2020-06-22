//
//  LoaderView.swift
//  TodoList
//
//  Created by Andrey Novikov on 6/18/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    
    private enum LoaderViewAnimationName: String {
        case strokeEndAnimation
    }
    
    var progress: CGFloat = 0 {
        didSet {
            progressOldValue = oldValue
            loaderShapeLayer.strokeEnd = progress
            progressAnimation()
            
        }
    }
    
    var circleShapeColor: UIColor! {
        didSet {
            circleShapeLayer.strokeColor = circleShapeColor.cgColor
            circleShapeLayer.fillColor = UIColor.clear.cgColor
        }
    }
    
    var loaderShapeColor: UIColor! {
        didSet {
            loaderShapeLayer.strokeColor = loaderShapeColor.cgColor
            loaderShapeLayer.fillColor = UIColor.clear.cgColor
        }
    }
    
    // MARK: - Private properties
    private var circleShapeLayer: CAShapeLayer! {
        didSet {
            circleShapeLayer.strokeStart = 0
            circleShapeLayer.strokeEnd = 1
        }
    }
    private var loaderShapeLayer: CAShapeLayer!
    private var progressOldValue: CGFloat = 0
    
    
    // MARK: - Live cycle
    override func draw(_ rect: CGRect) {
        
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circleShapeLayer = CAShapeLayer()
        loaderShapeLayer = CAShapeLayer()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Live cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupShapeLayer(circleShapeLayer)
        setupShapeLayer(loaderShapeLayer)
        
        loaderShapeLayer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
        
        progressAnimation()
    }
    
    func removeAnimation() {
        loaderShapeLayer.removeAnimation(forKey: LoaderViewAnimationName.strokeEndAnimation.rawValue)
    }
    
    
    // MARK: - Private methods
    private func getPAth() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: .zero, radius: 30, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        return path
    }
    
    private func setupShapeLayer(_ shapeLayer: CAShapeLayer) {
        shapeLayer.lineWidth = 6
        shapeLayer.path = getPAth().cgPath
        shapeLayer.position = center
        
        self.layer.addSublayer(shapeLayer)
    }
    
    private func progressAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressOldValue
        animation.toValue = progress
        animation.duration = 0.5
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = .both
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        loaderShapeLayer.add(animation, forKey: LoaderViewAnimationName.strokeEndAnimation.rawValue)
    }
}
