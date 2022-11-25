//
//  SceneDelegate.swift
//  Subway
//
//  Created by WalterCho on 2022/11/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let mainVC = MainVC()
        let navigation = UINavigationController(rootViewController: mainVC)
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}

