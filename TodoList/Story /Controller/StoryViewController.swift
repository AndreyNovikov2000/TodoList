//
//  StoryViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/2/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

    private let storyTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(storyTableView)
        storyTableView.translatesAutoresizingMaskIntoConstraints = false
        storyTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        storyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        storyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        storyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
