//
//  SettingsViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/6/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingViewController(_ settingsViewController: SettingsViewController, didSelectedMainScreen mainScreen: Settings)
}

class SettingsViewController: UITableViewController {
    
    // MARK: - External [roperties
    weak var myDelegate: SettingsViewControllerDelegate?
    
    // MARK: - Private properties
    private let elements = Settings.allCases
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseId)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        setupNavigationBar()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseId, for: indexPath) as! SettingsCell
        let settingsElement = elements[indexPath.row]
        cell.set(with: settingsElement)
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        
        switch element {
        case .mainScareen:
            myDelegate?.settingViewController(self, didSelectedMainScreen: element)
        case .language:
            performSegue(withIdentifier: "goToTheLanguageVC", sender: self)
        }
    }
    
    // MARK: - Private properties
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
    }
}

