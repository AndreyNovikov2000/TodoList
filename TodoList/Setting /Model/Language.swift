//
//  Language.swift
//  TodoList
//
//  Created by Andrey Novikov on 7/7/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation


struct Language {
    let languageName: String
    let languageFlag: String
    let languageLocale: String
    
    static func getLanguages() -> [Language] {
        return [
            Language(languageName: "English", languageFlag: "🇺🇸", languageLocale: "en"),
            Language(languageName: "Español", languageFlag: "🇪🇸", languageLocale: "es"),
            Language(languageName: "Deutsche", languageFlag: "🇩🇪", languageLocale: "de"),
            Language(languageName: "Русский", languageFlag: "🇷🇺", languageLocale: "ru"),
            Language(languageName: "Français", languageFlag: "🇫🇷", languageLocale: "fr"),
            Language(languageName: "繁體中文", languageFlag: "🇨🇳", languageLocale: "zh"),
            Language(languageName: "日本人", languageFlag: "🇯🇵", languageLocale: "ja"),
            Language(languageName: "한국어", languageFlag: "🇰🇷", languageLocale: "ko"),
        ]
    }
}
