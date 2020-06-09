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
    var list: Lists?
    var dismissComplition: (() -> Void)?
    
    // MARK: - Private properties
    private let headerListView = HeaderListView()
    private var listAlertView: ListAlertView! = UIView.loadFromNib()
    private var visualEffectView: UIVisualEffectView!
    private var alertView: AlertView!
    private var menuTableView: MenuTableView<ListMenu>!
    
    private let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let storageManager = StorageManager()
    private var defaulListtColor = UIColor(red: 0.1147335842, green: 0.5975336432, blue: 0.8779801726, alpha: 1)
    private var listIsEditing = false
    
    
    // MARK: - Live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if list == nil {
            list = storageManager.createEntity(entityName: "Lists", contex: contex)
        }
        
        if let title = list?.title, let count = list?.detailLists?.count, let color = UIColor.color(withData: list?.titntColor) {
            headerListView.setListTitleLabel(with: title)
            headerListView.setListCountLabel(with: String(count))
            defaulListtColor = color
        }
        
        setupTable()
        setupTaskListButton()
        setupHeandleView()
        setupHeaderListView()
        setupKeyboardNotification()
        
        presentationController?.delegate = self
        view.backgroundColor = defaulListtColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Objc func
    @objc fileprivate func heandleKeyboardNotification(notification: Notification) {
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
    
    @objc fileprivate func heandleTapVisualEffectView() {
        menuAnimateOut()
    }
    
    
    // MARK: - IBAction
    @IBAction func taskListButtonPressed() {
        listIsEditing ? menuAnimateOut() : menuAnimateIn()
    }
    
    private func menuAnimateIn() {
        listIsEditing = true
        setupVisualEffectView()
        setupMenuTableView()
        view.bringSubviewToFront(taskListButton)
        menuTableView.visualEffectAnimateIn(duration: 0.4, visualEffectView: visualEffectView, compliteAnimation: nil)
        taskListButton.animateInTransition(duration: 0.3, compliteAnimation: nil)
    }
    
    private func menuAnimateOut() {
        listIsEditing = false
        menuTableView.visualEffectViewAnimateOut(duration: 0.4, visualEffectView: visualEffectView) { [weak self] in
            self?.removeMenuTableView()
            self?.removeVisualEffectView()
        }
        taskListButton.animateOutTransition(duration: 0.3, compliteAnimation: nil)
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
            }
        }
        
        view.addSubview(menuTableView)
        
        menuTableView.bottomAnchor.constraint(equalTo: taskListButton.topAnchor, constant: -16).isActive = true
        menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        menuTableView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        menuTableView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func removeMenuTableView() {
        menuTableView.removeFromSuperview()
    }
    
    
    // MARK: - Private methods
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTable() {
        table.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.reuseId)
        table.backgroundColor = defaulListtColor
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.dataSource = self
        table.delegate = self
        table.tableHeaderView = headerListView
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
    
    private func setupSubListViewController(with detailList: DetailList?) {
        let subListVC: SubListViewController = SubListViewController()
        
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
            self.storageManager.save(self.contex)
            self.setupKeyboardNotification()
        }
        
        present(subListVC, animated: true, completion: nil)
    }
    
    private func setupListAlertView() {
        listAlertView = UIView.loadFromNib()
        listAlertView.center = view.center
        listAlertView.myDelegate = self
        view.addSubview(listAlertView)
    }
    
    private func setupAlertView() {
        alertView = .loadFromNib()
        alertView.myDelegate = self
        alertView.center = view.center
        view.addSubview(alertView)
    }
    
    private func setupVisualEffectView() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.effect = UIBlurEffect(style: .extraLight)
        visualEffectView.frame = view.frame
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(heandleTapVisualEffectView)))
        view.addSubview(visualEffectView)
    }
    
    private func removeVisualEffectView() {
        visualEffectView.removeFromSuperview()
        visualEffectView = nil
    }
    
    private func animateIn(on view: UIView) {
        view.visualEffectAnimateIn(duration: 0.4, visualEffectView: UIVisualEffectView(), compliteAnimation: nil)
    }
    
    private func animateOut(on view: UIView, compliteAnimation: (() -> Void)?) {
        view.visualEffectViewAnimateOut(duration: 0.4, visualEffectView: visualEffectView, compliteAnimation: compliteAnimation)
    }
    
    private func saveList() {
        let listTitle = headerListView.getTitle()
        let colorData = defaulListtColor.encode()
        
        list?.title = listTitle
        list?.titntColor = colorData
        
        do {
            try contex.save()
        } catch let error as NSError {
            print("Error - \(error.userInfo)")
        }
    }
    
    private func deleteContextualAction(with indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, complition) in
            if let self = self {
                self.deleteCellWith(indexPath: indexPath)
                complition(true)
            }
        }
        
        deleteAction.backgroundColor = UIColor(red: 0.9568627451, green: 0.368627451, blue: 0.4274509804, alpha: 1)
        deleteAction.image = UIImage(systemName: "trash")
        
        return deleteAction
    }
    
    private func deleteCellWith(indexPath: IndexPath) {
        guard let detailListTask = list?.detailLists?[indexPath.row] as? DetailList else { return }
        let subLists = list?.detailLists?.mutableCopy() as? NSMutableOrderedSet
        
        subLists?.remove(detailListTask)
        list?.detailLists = subLists
        table.deleteRows(at: [indexPath], with: .left)
        storageManager.delete(contex, object: detailListTask)
        storageManager.save(contex)
    }
}


// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = list?.detailLists?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reuseId, for: indexPath) as! TaskListCell
        
        if let detailList = list?.detailLists?[indexPath.row] as? DetailList {
            cell.set(detailList: detailList)
            cell.myDelegate = self
        }
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteContextualAction(with: indexPath)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailList = list?.detailLists?[indexPath.row] as? DetailList
        NotificationCenter.default.removeObserver(self)
        setupSubListViewController(with: detailList)
    }
}


// MARK: - TaskListCellDelegate
extension ListViewController: TaskListCellDelegate {
    func taskListCellCompliteButtonPressed(_ taskListCell: TaskListCell) {
        guard let indexPath = table.indexPath(for: taskListCell) else { return }
        guard let count = list?.detailLists?.count else { return }
        
        taskListCell.cellAnimateOut { [weak self] in
            self?.deleteCellWith(indexPath: indexPath)
            self?.headerListView.setListCountLabel(with: String(count - 1))
        }
    }
}


// MARK: - HeaderListViewDelegate
extension ListViewController: HeaderListViewDelegate {
    func headerListViewDidEditingButtonTapped(_ headerListView: HeaderListView) {
        setupVisualEffectView()
        setupListAlertView()
        animateIn(on: listAlertView)
        
        if let text = list?.title{
            listAlertView.titleListTextField.text = text
        }
        listAlertView.titleListTextField.becomeFirstResponder()
    }
}


// MARK: - ListAlertViewDelegate
extension ListViewController: ListAlertViewDelegate {
    func listAlertViewSaveButtonTapped(_ listAlertView: ListAlertView) {
        animateOut(on: listAlertView) { [weak self] in
            self?.listAlertView.removeFromSuperview()
            self?.removeVisualEffectView()
        }
    }
    
    func listAlertViewCancelButtonTapped(_ listAlertView: ListAlertView) {
        animateOut(on: listAlertView) { [weak self] in
            self?.listAlertView.removeFromSuperview()
            self?.removeVisualEffectView()
        }
    }
    
    func listAlertView(_ listAlertView: ListAlertView, didSelectedColor color: UIColor) {
        table.backgroundColor = color
        view.backgroundColor = color
        defaulListtColor = color
        table.reloadData()
    }
    
    func listAlertViewTitleTextFieldDidEndEditing(_ listAlertView: ListAlertView, titleListTextFeild: UITextField) {
        if let text = titleListTextFeild.text {
            headerListView.setListTitleLabel(with: text)
        }
    }
}


// MARK: - AlertViewDelegate
extension ListViewController: AlertViewDelegate {
    func alertViewDeleteButtonPressed(_ alertView: AlertView) {
        guard let list = list else { return }
        animateOut(on: alertView) { [weak self] in
            self?.menuAnimateOut()
            self?.alertView.removeFromSuperview()
            self?.dismiss(animated: true, completion: nil)
        }
        
        storageManager.delete(contex, object: list)
        storageManager.save(contex)
        dismissComplition?()
    }
    
    func alertViewCancelButtonPressed(_ alertView: AlertView) {
        animateOut(on: alertView) { [weak self] in
            self?.menuAnimateOut()
            self?.alertView.removeFromSuperview()
        }
    }
}


// MARK: - UIAdaptivePresentationControllerDelegate
extension ListViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        saveList()
        dismissComplition?()
    }
}
