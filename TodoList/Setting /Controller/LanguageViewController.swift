//
//  LanguageViewController.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/7/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class LanguageViewController: UITableViewController {
    
    private let localizationSystem = LocalizationSystem.sharedInstance
    private let languages = Language.getLanguages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem?.title = ""
        tableView.tableFooterView = UIView()
        
       
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        let language = languages[indexPath.row]
        
        cell.selectionStyle = .none
        cell.textLabel?.text = language.languageFlag + language.languageName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 21)
        
        if language.languageLocale == localizationSystem.getLanguage() {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let locale = languages[indexPath.row].languageLocale
        update()
        cell.accessoryType = .checkmark
        localizationSystem.setLanguage(languageCode: locale)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: UIResponder.updateLanguage), object: nil)
    }
    
    // MARK: - Private methods
    
    private func update() {
        for index in 0..<languages.count {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
    }
}


extension UIResponder {
    static let updateLanguage: String = "updateLanguage"
}
