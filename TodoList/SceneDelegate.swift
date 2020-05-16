//
//  SceneDelegate.swift
//  TodoList
//
//  Created by Andrey Novikov on 5/10/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let secondScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: secondScene)
        window?.rootViewController = UINavigationController(rootViewController: ContanierViewController())
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
    }
}

