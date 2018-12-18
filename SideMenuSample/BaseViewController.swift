//
//  BaseViewController.swift
//  SideMenuSample
//
//  Created by KS on 2018/12/10.
//  Copyright © 2018 KS. All rights reserved.
//

import UIKit

final class BaseViewController: UIViewController {
    
    private let interactor = Interactor()
    
    // MARK: - IBActions
    
    @IBAction private func didTapMenuButton(_ sender: UIBarButtonItem) {
        transitionToMenu()
    }
    
    @IBAction private func screenEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .right)
        
        MenuHelper.mapGestureStateToInteractor(gestureState: sender.state, progress: progress, interactor: interactor) {
            self.transitionToMenu()
        }
    }
    
    private func transitionToMenu() {
        weak var weakSelf = self
        let menuViewController = MenuViewController.instantiate(interactor: interactor, transitioningDelegate: weakSelf)
        present(menuViewController, animated: true, completion: nil)
    }
}

extension BaseViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
