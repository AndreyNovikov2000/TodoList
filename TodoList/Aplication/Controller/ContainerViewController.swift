//
//  ContainerViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/7/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    enum MenuSate {
        case disclosed
        case closed
    }
    
    // MARK: - Private properties
    private var taskViewController: UIViewController!
    private var settinsViewController: UIViewController!
    private var visualEffectView: UIVisualEffectView!
    
    
    private var animators = [UIViewPropertyAnimator]()
    private var animationProgress: CGFloat = 0
    private var menuState: MenuSate = .closed
    private var cardVisisble = false
    private var nextState: MenuSate {
        cardVisisble ? .disclosed : .closed
    }
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTaskViewController()
        
        view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(hendlePanGesture)))
    }
    
    
    @objc private func hendlePanGesture(gesture: UISwipeGestureRecognizer) {
       configureSettingsViewController()
        
//        let translation = gesture.translation(in: view)
//        let progress = translation.x / Constants.screenBounds.width
//        let fractionComplite = cardVisisble ? -progress : progress
        
        switch gesture.direction {
        case .right:
            print("rigt")
        default:
            print("left")
        }
        
        switch gesture.state {
        case .began:
            startAnimationTransition(with: nextState, duration: 0.15)
        case .changed:
            updateInteractiveTransition(with: 0)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    private func animateTransitionIfNeded(with state: MenuSate, duration: TimeInterval) {
        if animators.isEmpty {
            
            let transitionAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
                switch state {
                case .disclosed:
                    self.taskViewController.view.frame.origin.x = 0
                case .closed:
                    self.taskViewController.view.frame.origin.x = Constants.screenBounds.width / 2
                }
            }
        
            transitionAnimator.startAnimation()
            animators.append(transitionAnimator)
            
            transitionAnimator.addCompletion { _ in
                self.cardVisisble.toggle()
                self.animators.removeAll()
            }
        }
    }
    
    
    // began
    private func startAnimationTransition(with state: MenuSate, duration: TimeInterval) {
        if animators.isEmpty {
            animateTransitionIfNeded(with: state, duration: duration)
        }
        
        for animator in animators {
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
        }
    }
    
    // change
    private func updateInteractiveTransition(with fractionComplite: CGFloat) {
        for animator in animators {
            animator.fractionComplete = fractionComplite + animationProgress
        }
    }
    
    // ended
    private func continueInteractiveTransition() {
        for animator in animators {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    
    
    // MARK: - Private methods
    
    private func configureTaskViewController() {
        let taskVC: TaskViewController  = .loadFromStoryboard()
        taskVC.myDelegate = self
        taskViewController = UINavigationController(rootViewController: taskVC)
        
        view.addSubview(taskViewController.view)
        addChild(taskViewController)
    }
    
    private func configureSettingsViewController() {
        if settinsViewController == nil {
            let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() as? SettingsViewController
            settinsViewController = settingsVC
            settingsVC?.myDelegate = self
            view.insertSubview(settinsViewController.view, at: 0)
            addChild(settinsViewController)
        }
    }
    
    private func showMenu(with state: MenuSate) {
        if state == .closed {
            
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else { return }
                
                self.taskViewController.view.frame.origin.x = Constants.screenBounds.width / 2
                
            })
            
            cardVisisble = true
            
        } else {
            
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else { return }
                
                self.taskViewController.view.frame.origin.x = 0
                
            })
            
            cardVisisble = false
        }
    }
}



// MARK: - TaskViewControllerDelegate
extension ContainerViewController: TaskViewControllerDelegate {
    func taskViewControllerMenuButtonPressed(_ taskViewController: TaskViewController) {
        configureSettingsViewController()
        showMenu(with: nextState)
    }
}


// MARK: - SettingsViewControllerDelegate
extension ContainerViewController: SettingsViewControllerDelegate {
    func settingViewController(_ settingsViewController: SettingsViewController, didSelectedMainScreen mainScreen: Settings) {
        showMenu(with: nextState)
    }
}
