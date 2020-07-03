//
//  ListViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/19/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit


class ListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var taskListButton: UIButton!
    @IBOutlet weak var heandleView: UIView!
    
    // MARK: - Public properties
    let storageManager = StorageManager()
    let listModel = ListModel()
    var dismissComplition: (() -> Void)?
    
    var list: Lists?
    var alertView: AlertView!
    var listAlertView: ListAlertView = .loadFromNib()
    let headerListView = HeaderListView()
    var defaulListtColor = UIColor(red: 0.1147335842, green: 0.5975336432, blue: 0.8779801726, alpha: 1)
    
    // MARK: - Private properties
    private let notificationManager = NotificationManager()
    private var visualEffectView: UIVisualEffectView!
    private var menuTableView: MenuTableView<ListMenu>!
    private var tapGesture: UITapGestureRecognizer!
    private var listIsEditing = false
    
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupList()
        
        setupTable()
        setupTaskListButton()
        setupHeandleView()
        setupHeaderListView()
        setupKeyboardNotification()
        
        presentationController?.delegate = self
        view.backgroundColor = defaulListtColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func setupList() {
        if list == nil {
            list = storageManager.createEntity(entityName: "Lists")
        }
        
        if let title = list?.title, let count = list?.detailLists?.count, let color = UIColor.color(withData: list?.titntColor) {
            headerListView.setListTitleLabel(with: title)
            headerListView.setListCountLabel(with: String(count))
            defaulListtColor = color
        }

    }
    
    
    // MARK: - Objc methods
    @objc func heandleKeyboardNotification(notification: Notification) {
        guard let keyboardSize = notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let listAlertViewFrame = listAlertView.frame
        let keyBoardOffSetY = view.frame.height - keyboardSize.height
        
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            // if keyabord cover alert view
            if view.center.y + listAlertViewFrame.height / 2 > keyBoardOffSetY {
                
                let yOffSet = view.center.y + listAlertViewFrame.height / 2 - keyBoardOffSetY
                view.frame.origin.y -= yOffSet - 40
            }
        } else {
            view.frame.origin.y = 0
        }
    }
    
    @objc func heandleTapVisualEffectView() {
        menuAnimateOut()
    }
    
    
    // MARK: - IBAction
    @IBAction func taskListButtonPressed() {
        listIsEditing ? menuAnimateOut() : menuAnimateIn()
    }
    
    
    // MARK: - Public methods
    
    func menuAnimateIn() {
        listIsEditing = true
        setupVisualEffectView()
        setupMenuTableView()
        view.bringSubviewToFront(taskListButton)
        menuTableView.visualEffectAnimateIn(duration: 0.4, visualEffectView: visualEffectView, compliteAnimation: nil)
        taskListButton.animateInTransition(duration: 0.3, compliteAnimation: nil)
    }
    
    func menuAnimateOut() {
        listIsEditing = false
        menuTableView.visualEffectViewAnimateOut(duration: 0.4, visualEffectView: visualEffectView) { [weak self] in
            self?.removeMenuTableView()
            self?.removeVisualEffectView()
        }
        taskListButton.animateOutTransition(duration: 0.3, compliteAnimation: nil)
    }
    
    func removeMenuTableView() {
        menuTableView.removeFromSuperview()
    }
    
    
    func setupSubListViewController(with detailList: DetailList?) {
        let subListVC: CreateListViewController = CreateListViewController()
        
        subListVC.modalPresentationStyle = .formSheet
        subListVC.listColor = defaulListtColor
        subListVC.detailList = detailList
        subListVC.heandleDismiss = { [weak self] detailList in
            guard let self = self else { return }
            guard let detailList = detailList else { return }
            
            let copySet = self.list?.detailLists?.mutableCopy() as? NSMutableOrderedSet
            copySet?.add(detailList)
            self.list?.detailLists = copySet
            self.table.reloadData()
            self.storageManager.save()
            self.setupKeyboardNotification()
            self.headerListView.setListCountLabel(with: String(self.list?.detailLists?.count ?? 0))
        }
        
        present(subListVC, animated: true, completion: nil)
    }
    
    func setupVisualEffectView() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.effect = UIBlurEffect(style: .light)
        visualEffectView.frame = view.frame
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(heandleTapVisualEffectView))
        visualEffectView.addGestureRecognizer(tapGesture)
        view.addSubview(visualEffectView)
    }
    
    func removeVisualEffectView() {
        visualEffectView.removeFromSuperview()
        visualEffectView = nil
    }
    
    func animateIn(on view: UIView) {
        view.visualEffectAnimateIn(duration: 0.4, visualEffectView: UIVisualEffectView(), compliteAnimation: nil)
    }
    
    func animateOut(on view: UIView, compliteAnimation: (() -> Void)?) {
        view.visualEffectViewAnimateOut(duration: 0.4, visualEffectView: visualEffectView, compliteAnimation: compliteAnimation)
    }
    
    func setupListAlertView() {
        listAlertView = UIView.loadFromNib()
        listAlertView.center = view.center
        listAlertView.myDelegate = self
        view.addSubview(listAlertView)
    }
    
    func deleteCellWith(indexPath: IndexPath) {
        guard let detailListTask = list?.detailLists?[indexPath.row] as? DetailList else { return }
        let subLists = list?.detailLists?.mutableCopy() as? NSMutableOrderedSet
        
        subLists?.remove(detailListTask)
        list?.detailLists = subLists
        table.deleteRows(at: [indexPath], with: .left)
        storageManager.delete(object: detailListTask)
        storageManager.save()
    }
    
    func deleteContextualAction(with indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, complition) in
            if let self = self {
                self.deleteCellWith(indexPath: indexPath)
                complition(true)
            }
        }
        
        deleteAction.backgroundColor = UIColor(red: 0.9568627451, green: 0.368627451, blue: 0.4274509804, alpha: 1)
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        } else {
            // Fallback on earlier versions
        }
        
        return deleteAction
    }
    
    func saveList() {
        let listTitle = headerListView.getTitle()
        let colorData = defaulListtColor.encode()
        
        list?.title = listTitle
        list?.titntColor = colorData
        storageManager.save()
    }
    
    
    // MARK: - Private methods
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTable() {
        table.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.reuseId)
        table.tableHeaderView = headerListView
        table.backgroundColor = defaulListtColor
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.dragInteractionEnabled = true
        table.dataSource = self
        table.delegate = self
        table.dragDelegate = self
    }
    
    private func setupTaskListButton() {
        taskListButton.layer.cornerRadius = taskListButton.frame.height / 2
        taskListButton.setTitle("", for: .normal)
        taskListButton.backgroundColor = .black
        taskListButton.setImage(UIImage(named: "AddShape"), for: .normal)
        view.bringSubviewToFront(taskListButton)
    }
    
    private func setupHeandleView() {
        heandleView.backgroundColor = UIColor(red: 0.145, green: 0.165, blue: 0.192, alpha: 1)
        heandleView.alpha = 0.2
        heandleView.layer.cornerRadius = 3
    }
    
    private func setupHeaderListView() {
        headerListView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        headerListView.myDelegate = self
        if let count = list?.detailLists?.count {
            headerListView.setListCountLabel(with: String(count))
        }
    }
    
    private func setupAlertView() {
         alertView = .loadFromNib()
         alertView.myDelegate = self
         alertView.center = view.center
         view.addSubview(alertView)
     }
    
    private func setupMenuTableView() {
        menuTableView = MenuTableView(object: ListMenu.allCases)
        menuTableView.selectedComplitionItem = { [weak self] item in
            guard let self = self else { return }
            
            switch item {
                
            case .listSubTask:
                
                NotificationCenter.default.removeObserver(self)
                self.setupSubListViewController(with: nil)
                self.animateOut(on: self.menuTableView) {
                    self.menuAnimateOut()
                }
                
            case .deleteList:
                
                self.setupAlertView()
                self.animateIn(on: self.alertView)
                self.removeMenuTableView()
                self.visualEffectView.removeGestureRecognizer(self.tapGesture)
            }
        }
        
        view.addSubview(menuTableView)
        
        menuTableView.bottomAnchor.constraint(equalTo: taskListButton.topAnchor, constant: -16).isActive = true
        menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        menuTableView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        menuTableView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
}
