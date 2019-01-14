//
//  MenuViewController.swift
//  SideMenuSample
//
//  Created by KS on 2018/12/10.
//  Copyright © 2018 KS. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
    
    // MARK: - Factory
    
    static func instantiate() -> MenuViewController {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        guard let menuViewController = storyboard.instantiateInitialViewController() as? MenuViewController else {
            fatalError("MenuViewController is nil.")
        }
        return menuViewController
    }
}
