//
//  TaskViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol TaskViewControllerDelegate: class {
    func taskViewControllerMenuButtonPressed(_ taskViewController: TaskViewController)
}

class TaskViewController: UIViewController {
    
    // MARK: - External properties
    weak var myDelegate: TaskViewControllerDelegate?
    
    // MARK: - Public properties
    let model = Model()
    let storageManager = StorageManager()
    let taskTableView = TaskTableView()
    var tasks2d = [[Task]]()
    var lists = [Lists]()
    
    
    // MARK: - IBOultets
    @IBOutlet weak var addNewTaskButton: UIButton!
    
    // MARK: - Private properties
    private var menuTableView: MenuTableView<Menu>!
    private var visualEffectView: UIVisualEffectView!
    private var isCreating = false
    
    
    // MARK: - Live Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lists = model.getList()
        tasks2d = model.getTasks()
        setupNavigationBar()
        setupTaskTableView()
        setupAddButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateLanguage), name: NSNotification.Name(rawValue: UIResponder.updateLanguage), object: nil)
    }
    
    
    // MARK: - IBAction & Selector methods
    @IBAction func heandleNewTaskButtonPressed() {
        isCreating ? animateOutMenu() : animateInMemu()
    }
    
    @objc private func menuButtonPressed() {
        myDelegate?.taskViewControllerMenuButtonPressed(self)
    }
    
    @objc private func heandleVisualEffectViewTapped() {
        animateOutMenu()
    }
    
    @objc private func handleUpdateLanguage() {
        taskTableView.reloadData()
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
        
        
        // selected first item of story 
        taskTableView.headerView.storyCollectionView.performClosure = {
            
        }
        
        taskTableView.separatorStyle = .none
        
        taskTableView.footerView.listCollectionView.delegate = self
        taskTableView.footerView.listCollectionView.dataSource = self
        taskTableView.footerView.listCollectionView.dragDelegate = self
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.dragDelegate = self
        
        taskTableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1).isActive = true
        taskTableView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1).isActive = true
        taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Detail"), style: .plain, target: self, action: #selector(menuButtonPressed))
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
                
            case .story:
                
                self?.animateOutMenu()
                self?.present(StoryViewController(), animated: true, completion: nil)
            }
        }
        
        view.addSubview(menuTableView)
        
        menuTableView.bottomAnchor.constraint(equalTo: addNewTaskButton.topAnchor, constant: -16).isActive = true
        menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        menuTableView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        menuTableView.heightAnchor.constraint(equalToConstant: CGFloat(Constants.menuTableViewCellHeight * CGFloat(Menu.allCases.count))).isActive = true
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
    
    func presentSubTaskColtroller(with task: Task?) {
        let subTaskVC = CreateTaskViewController()
        
        subTaskVC.modalPresentationStyle = .pageSheet
        subTaskVC.task = task
        subTaskVC.heandleDismiss = { [weak self] in
            guard let self = self else { return }
            self.tasks2d = self.model.getTasks()
            self.taskTableView.reloadData()
        }
        
        present(subTaskVC, animated: true, completion: nil)
    }
    
    func presentListViewController(with list: Lists?) {
        let listVC: ListViewController = .loadFromStoryboard()
        listVC.modalPresentationStyle = .pageSheet
        listVC.list = list
        listVC.dismissComplition = { [weak self] in
            guard let self = self else { return }
            self.lists = self.model.getList()
            self.taskTableView.footerView.listCollectionView.reloadData()
        }
        
        present(listVC, animated: true, completion: nil)
    }
}

