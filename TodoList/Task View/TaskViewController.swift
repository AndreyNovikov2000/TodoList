//
//  TaskViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

import UIKit
import CoreData


class TaskViewController: UIViewController {
    
    // MARK: - IBOultets
    @IBOutlet weak var addNewTaskButton: UIButton!
    
    // MARK: - Private properties
    private let taskTableView = TaskTableView()
    private var menuTableView: MenuTableView!
    private var visualEffectView: UIVisualEffectView!
        
    private var isCreating = false
    
    
    // MARK: - Live Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTaskTableView()
        setupAddButton()
    }
    
    
    // MARK: - IBACtion
    @IBAction func heandleNewTaskButtonPressed() {
        isCreating ? animateOutMenu() : animateInMemu()
    }
    
    @objc private func heandleVisualEffectViewTapped() {
        animateOutMenu()
    }
    
    
    // MARK: - Private methods
    private func setupAddButton() {
        addNewTaskButton.layer.cornerRadius = addNewTaskButton.frame.height / 2
        addNewTaskButton.setTitle("", for: .normal)
        addNewTaskButton.backgroundColor = .black
        addNewTaskButton.setImage(UIImage(named: "AddShape"), for: .normal)
        view.bringSubviewToFront(addNewTaskButton)
    }
    
    private func setupTaskTableView() {
        view.addSubview(taskTableView)
        taskTableView.separatorStyle = .none
        
        taskTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        taskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    
    private func setupMenuTableView() {
        menuTableView = MenuTableView()
        menuTableView.menuDelegate = self
        
        view.addSubview(menuTableView)
        
        menuTableView.bottomAnchor.constraint(equalTo: addNewTaskButton.topAnchor, constant: -16).isActive = true
        menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        menuTableView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        menuTableView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func removeMenuTableView() {
        menuTableView.removeFromSuperview()
    }
    
    private func setupVisualEffectView() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = view.frame
        visualEffectView.effect = UIBlurEffect(style: .dark)
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(heandleVisualEffectViewTapped)))
        view.addSubview(visualEffectView)
    }
    
    private func removeVisualEffectView() {
        visualEffectView.removeGestureRecognizer(UITapGestureRecognizer())
        visualEffectView.removeFromSuperview()
    }
    
    private func animateInMemu() {
        isCreating = true
        setupVisualEffectView()
        setupMenuTableView()
        view.bringSubviewToFront(addNewTaskButton)
        menuTableView.visualEffectAnimateIn(duration: 0.4, visualEffectView: visualEffectView, compliteAnimation: nil)
        addNewTaskButton.animateInTransition(duration: 0.3, compliteAnimation: nil)
    }
    
    private func animateOutMenu() {
        isCreating = false
        menuTableView.visualEffectViewAnimateOut(duration: 0.4, visualEffectView: visualEffectView) { [weak self] in
            self?.removeVisualEffectView()
            self?.removeMenuTableView()
        }
        addNewTaskButton.animateOutTransition(duration: 0.3, compliteAnimation: nil)
    }
}



// MARK: - MenuTableViewDelegate
extension TaskViewController: MenuTableViewDelegate {
    func menuTableView(_ menuTableView: MenuTableView, didSelectedElement menuElement: Menu) {
        switch menuElement {
        case .task:
            let createVC = SubViewController()
            
            createVC.modalPresentationStyle = .pageSheet
            createVC.heandleDismiss = {
                self.taskTableView.updateData()
            }
            
            animateOutMenu()
            present(createVC, animated: true, completion: nil)
            
        case .list:
            let listVC: ListViewController = UIViewController.loadFromStoryboard()
            listVC.modalPresentationStyle = .pageSheet
            animateOutMenu()
            present(listVC, animated: true, completion: nil)
        }
    }
}
