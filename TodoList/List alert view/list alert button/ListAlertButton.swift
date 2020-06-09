//
//  ListAlertButton.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/25/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class ListAlertButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
}
