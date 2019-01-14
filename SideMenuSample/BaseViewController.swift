//
//  BaseViewController.swift
//  SideMenuSample
//
//  Created by KS on 2018/12/10.
//  Copyright © 2018 KS. All rights reserved.
//

import UIKit

protocol BaseViewControllerDelegate {
    func menuButtonTapped()
}

final class BaseViewController: UIViewController {
    
    var delegate: BaseViewControllerDelegate?
    
    // MARK: - Factory
    
    static func instantiate() -> BaseViewController {
        let storyboard = UIStoryboard(name: "BaseViewController", bundle: nil)
        guard let baseViewController = storyboard.instantiateInitialViewController() as? BaseViewController else {
            fatalError("BaseViewController is nil.")
        }
        return baseViewController
    }
    
    // MARK: - IBActions
    
    @IBAction private func didTapMenuButton(_ sender: UIBarButtonItem) {
        delegate?.menuButtonTapped()
    }
}
