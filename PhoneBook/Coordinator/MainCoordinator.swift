//
//  MainCoordinator.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit

protocol Coordinator {
    func start()
}

class MainCoordinator: Coordinator {
    let rootViewController: UINavigationController
    let coordinator: ContactListCoordinator
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        coordinator = ContactListCoordinator(presenter: rootViewController)
    }
    
    func start() {
        window.rootViewController = rootViewController
        coordinator.start()
        window.makeKeyAndVisible()
    }
}
