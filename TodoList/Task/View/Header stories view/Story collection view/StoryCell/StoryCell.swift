//
//  StoryCell.swift
//  TodoList
//
//  Created by Andrey Novikov on 6/15/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class StoryCell: UICollectionViewCell {
    static let reuseId = "StoryCell"
    
    let circleColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    let progressColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    var isCreatingCell = false
    
    // MARK: - Private properties
    private let loaderView: LoaderView = {
        let view = LoaderView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraintsForLoaderView()
        if !isCreatingCell {
            addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(heandlelongGesture)))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func heandlelongGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            scaleAnimation(isScaling: false)
        case .ended:
            scaleAnimation(isScaling: true)
            self.loaderView.progress += CGFloat.random(in: 0.1...0.5)
            
        default:
            break
        }
    }
    
    // MARK: - Live cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
    }
    
    override func prepareForReuse() {
        loaderView.removeAnimation()
    }
    
    // MARK: - Public methods
    func set(indexPath: CGFloat) {
        loaderView.progress = indexPath
        loaderView.circleShapeColor = circleColor
        loaderView.loaderShapeColor = progressColor
    }
    
    
    // MARK: - Private methods
    private func setupConstraintsForLoaderView() {
        addSubview(loaderView)
        
        loaderView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loaderView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loaderView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        loaderView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    private func scaleAnimation(isScaling: Bool) {
        if isScaling {
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform.identity
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(scaleX: 1.13, y: 1.13)
            }
        }
    }
}
