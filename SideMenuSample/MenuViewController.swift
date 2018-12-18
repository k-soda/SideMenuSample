//
//  MenuViewController.swift
//  SideMenuSample
//
//  Created by KS on 2018/12/10.
//  Copyright © 2018 KS. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
    
    private var interactor: Interactor?
    
    // MARK: - Factory
    
    static func instantiate(interactor: Interactor, transitioningDelegate: UIViewControllerTransitioningDelegate?) -> MenuViewController {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        
        guard let menuViewController = storyboard.instantiateInitialViewController() as? MenuViewController else {
            fatalError("MenuViewController is nil.")
        }
        
        menuViewController.interactor = interactor
        menuViewController.transitioningDelegate = transitioningDelegate
        
        return menuViewController
    }
    
    // MARK: - IBActions
    
    @IBAction private func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func panGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .left)
        
        MenuHelper.mapGestureStateToInteractor(gestureState: sender.state, progress: progress, interactor: interactor) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
