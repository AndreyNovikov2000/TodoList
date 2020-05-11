//
//  TaskViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

import UIKit

class TaskViewController: UIViewController {
    
    // MARK: - IBOultets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewTaskButton: UIButton!
    
    // MARK: - Live Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupTableView()
        setupAddButton()
    }
    
    // MARK: - IBACtion
    @IBAction func heandleNewTaskButtonPressed() {
        let vc = SubViewController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
    
    private func setupAddButton() {
        addNewTaskButton.layer.cornerRadius = addNewTaskButton.frame.height / 2
        addNewTaskButton.setTitle("", for: .normal)
        addNewTaskButton.backgroundColor = .black
        addNewTaskButton.setImage(UIImage(named: "AddShape"), for: .normal)
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// MARK: - UITableViewDataSource
extension TaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hello"
        
        return cell
        
    }
}

// MARK: - UITableViewDelegate
extension TaskViewController: UITableViewDelegate {
    
}
