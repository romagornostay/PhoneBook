//
//  UINavigationController.swift
//  PhoneBook
//
//  Created by SalemMacPro on 1.6.21.
//

import UIKit

extension UINavigationController {
    func pushViewControllerFromLeft(_ controller: UIViewController){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        
        
    }
}
