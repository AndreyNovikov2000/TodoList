//
//  ListColor.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/20/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

struct ListColor {
    static func getColors() -> [UIColor] {
        guard let pathToFile = Bundle.main.path(forResource: "colors", ofType: "plist") else { return [UIColor]() }
        guard let colorsData = NSArray(contentsOfFile: pathToFile) else { return [UIColor]() }
        var colors = [UIColor]()
        
        for dictinary in colorsData {
            let colorDictinary = dictinary as! NSDictionary
            
            let red = colorDictinary["red"] as! Int
            let green = colorDictinary["green"] as! Int
            let blue = colorDictinary["blue"] as! Int
            
            let color = UIColor(r: CGFloat(red), g: CGFloat(green), b: CGFloat(blue))
            
            colors.append(color)
        }
        
        return colors
    }
}
