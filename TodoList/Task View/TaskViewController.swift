//
//  TaskViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    // MARK: - IBOultets
    @IBOutlet weak var addNewTaskButton: UIButton!
    
    // MARK: - Private properties
    private let taskTableView = TaskTableView()
    private var menuTableView: MenuTableView<Menu>!
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
        
        // selected task
        taskTableView.presentationClosure = { [weak self] task in
            self?.presentSubTaskColtroller(with: task)
        }
        
        // selected list
        taskTableView.footerView.listCollectionView.presentationClosure = { [weak self] list in
            self?.presentListViewController(with: list)
        }
        
        taskTableView.separatorStyle = .none
        
        taskTableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1).isActive = true
        taskTableView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1).isActive = true
        taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
    private func setupMenuTableView() {
        menuTableView = MenuTableView(object: Menu.allCases)
        menuTableView.selectedComplitionItem = { [weak self] item in
            switch item {
            case .task:
                
                self?.animateOutMenu()
                self?.presentSubTaskColtroller(with: nil)
            case .list:
                self?.animateOutMenu()
                self?.presentListViewController(with: nil)
            }
        }
        
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
    
    private func presentSubTaskColtroller(with task: Task?) {
        let subTaskVC = SubViewController()
        
        subTaskVC.modalPresentationStyle = .pageSheet
        subTaskVC.task = task
        subTaskVC.heandleDismiss = { [weak self] in
            self?.taskTableView.updateData()
        }
        
        present(subTaskVC, animated: true, completion: nil)
    }
    
    private func presentListViewController(with list: Lists?) {
        let listVC: ListViewController = UIViewController.loadFromStoryboard()
        listVC.modalPresentationStyle = .pageSheet
        listVC.list = list
        listVC.dismissComplition = { [weak self] in
            self?.taskTableView.footerView.listCollectionView.update()
        }
        
        present(listVC, animated: true, completion: nil)
    }
}
