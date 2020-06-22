//
//  ContainerViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import KDCalendar

class ContanierViewController: UIViewController {
    
    
    private var taskViewController: UIViewController!
    private var calendarViewController: UIViewController!
    private let titleView = TitleView()
    private var isMove = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupNavigationBar()
        configureTaskViewController()
        configureCalendarViewController()
    }
    
    func showCalendarViewController(shouldMove: Bool) {
        if shouldMove {
            
            calendarViewController.view.frame.origin.y =  -calendarViewController.view.frame.height
//            taskViewController.view.alpha = 0
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 0.5,
                           options: .curveLinear,
                           animations: { [weak self] in
                            guard let self = self else { return }
                            
                            self.taskViewController.view.transform = CGAffineTransform(translationX: 0, y: self.taskViewController.view.frame.height)
                            
                            self.calendarViewController.view.frame.origin.y = 0
                            
            })
        } else {
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 0.5,
                           options: .curveLinear,
                           animations: { [weak self] in
                            guard let self = self else { return }
                            
                            self.calendarViewController.view.frame.origin.y = -self.calendarViewController.view.frame.height
                            self.taskViewController.view.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func configureTaskViewController() {
        taskViewController = UIStoryboard(name: "TaskViewController", bundle: nil).instantiateInitialViewController() as! TaskViewController
        
        addChild(taskViewController)
        view.addSubview(taskViewController.view)
    }
    
    private func configureCalendarViewController() {
        if calendarViewController == nil {
//            calendarViewController = CalendarViewController()
//            addChild(calendarViewController)
//            view.insertSubview(calendarViewController.view, at: 0)
        }
    }
    
    private func setupNavigationBar() {
//        let topBar = UIView(frame: view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
//        topBar.backgroundColor = .white
//        view.addSubview(topBar)
//        
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.view.backgroundColor = .white
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationItem.titleView = titleView
//        titleView.titleViewDelegate = self
    }
    
}


extension ContanierViewController: TitleViewDelegate {
    func calendarButtomPressed() {
        configureCalendarViewController()
        isMove.toggle()
        showCalendarViewController(shouldMove: isMove)
    }
}
