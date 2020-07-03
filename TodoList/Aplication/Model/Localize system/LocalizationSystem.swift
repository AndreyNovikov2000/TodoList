//
//  LocalizationSystem.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/1/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation

protocol Localization {
    func localizedStringForKey(key: String, comment: String) -> String
    func localizedImagePathForImg(imagename: String, type: String) -> String
    func setLanguage(languageCode: String)
    func getLanguage() -> String
}

class LocalizationSystem: Localization {
    
    
    static var sharedInstance: LocalizationSystem = LocalizationSystem()
    
    // MARK: - Private properties
    private var bundle: Bundle!
    
    
    // MARK: - Init
    init() {
        bundle = Bundle.main
    }
    
    // MARK: - Public methods
    func localizedStringForKey(key: String, comment: String) -> String {
        return bundle.localizedString(forKey: key, value: comment, table: nil)
    }
    
    func localizedImagePathForImg(imagename:String, type: String) -> String {
        guard let imagePath =  bundle.path(forResource: imagename, ofType: type) else {
            return ""
        }
        return imagePath
    }
    
    
    func setLanguage(languageCode: String) {
        var appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        appleLanguages.remove(at: 0)
        appleLanguages.insert(languageCode, at: 0)
        UserDefaults.standard.set(appleLanguages, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        if let languageDirectoryPath = Bundle.main.path(forResource: languageCode, ofType: "lproj")  {
            bundle = Bundle.init(path: languageDirectoryPath)
        } else {
            bundle = Bundle.main
        }
    }
    
    func getLanguage() -> String {
        let appleLanguages = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        let prefferedLanguage = appleLanguages[0]
        if prefferedLanguage.contains("-") {
            let array = prefferedLanguage.components(separatedBy: "-")
            return array[0]
        }
        return prefferedLanguage
    }
}
