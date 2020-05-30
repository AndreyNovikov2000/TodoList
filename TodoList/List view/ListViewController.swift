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
    
    // MARK: - Private properties
    private let headerListView = HeaderListView()
    private var listAlertView: ListAlertView!
    private var visualEffectView: UIVisualEffectView!
    
    private let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let storageManager = StorageManager()
    private var tasks = [Task]()
    
    // MARK: - Live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupTaskListButton()
        setupHeaderListView()
        
        setupKeyboardNotification()
        
        view.backgroundColor =  UIColor(red: 0.1147335842, green: 0.5975336432, blue: 0.8779801726, alpha: 1)
        
        tasks = try! storageManager.request(contex: contex)
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
                view.frame.origin.y -= yOffSet
            }
        } else {
            view.frame.origin.y = 0
        }
    }
    
    
    // MARK: - IBAction
    @IBAction func taskListButtonPressed() {
        let subListVC: SubListViewController = SubListViewController()//UIViewController.loadFromStoryboard()
        subListVC.modalPresentationStyle = .formSheet
        present(subListVC, animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(heandleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTable() {
        table.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.reuseId)
        table.backgroundColor =  UIColor(red: 0.1147335842, green: 0.5975336432, blue: 0.8779801726, alpha: 1)
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
    
    private func setupHeaderListView() {
        headerListView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        headerListView.myDelegate = self
    }
    
    private func setupListAlertView() {
        listAlertView = UIView.loadFromNib()
        listAlertView.center = view.center
        listAlertView.myDelegate = self
        view.addSubview(listAlertView)
    }
    
    private func removeListAlertView() {
        listAlertView.removeFromSuperview()
        listAlertView = nil
    }
    
    private func setupVisualEffectView() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.effect = UIBlurEffect(style: .extraLight)
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
    }
    
    private func removeVisualEffectView() {
        visualEffectView.removeFromSuperview()
        visualEffectView = nil
    }
    
    private func animateIn() {
        listAlertView.visualEffectAnimateIn(duration: 0.4, visualEffectView: visualEffectView, compliteAnimation: nil)
    }
    
    private func animateOut() {
        listAlertView.visualEffectViewAnimateOut(duration: 0.4, visualEffectView: visualEffectView) { [weak self] in
            self?.removeListAlertView()
            self?.removeVisualEffectView()
        }
    }
}


// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reuseId, for: indexPath) as! TaskListCell
        let task = tasks[indexPath.row]
        
        cell.set(task: task)
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    
}


// MARK: - HeaderListViewDelegate
extension ListViewController: HeaderListViewDelegate {
    func headerListViewDidEditingButtonTapped(_ headerListView: HeaderListView) {
        setupVisualEffectView()
        setupListAlertView()
        animateIn()
        
        listAlertView.titeListTextField.becomeFirstResponder()
    }
}


// MARK: - ListAlertViewDelegate
extension ListViewController: ListAlertViewDelegate {
    func listAlertViewSaveButtonTapped(_ listAlertView: ListAlertView) {
        animateOut()
    }
    
    func listAlertViewCancelButtonTapped(_ listAlertView: ListAlertView) {
        animateOut()
    }
    
    func listAlertView(_ listAlertView: ListAlertView, didSelectedColor color: UIColor) {
        table.backgroundColor = color
        view.backgroundColor = color
        table.reloadData()
    }
    
    func listAlertViewTitleTextFieldDidEndEditing(_ listAlertView: ListAlertView, titleListTextFeild: UITextField) {
        if let text = titleListTextFeild.text {
            headerListView.setListTitleLabel(with: text)
        }
    }
}
