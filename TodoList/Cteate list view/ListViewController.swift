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
    
    // MARK: - Private properties
    private let headerListView = HeaderListView()
    private var listAlertView: ListAlertView!
    private var visualEffectView: UIVisualEffectView!
    
    // MARK: - Live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupHeaderListView()
    }
    
    // MARK: - Private methods
    private func setupTable() {
        table.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.reuseId)
        table.backgroundColor =  UIColor(red: 0.1147335842, green: 0.5975336432, blue: 0.8779801726, alpha: 1)
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.tableHeaderView = headerListView
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reuseId, for: indexPath) as! TaskListCell
        
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
    }
    
    func listAlertViewTitleTextFieldDidEndEditing(_ listAlertView: ListAlertView, titleListTextFeild: UITextField) {
        if let text = titleListTextFeild.text {
            headerListView.setListTitleLabel(with: text)
        }
    }
}
