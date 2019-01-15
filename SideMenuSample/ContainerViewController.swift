//
//  ContainerViewController.swift
//  SideMenuSample
//
//  Created by KS on 2019/01/14.
//  Copyright © 2019 KS. All rights reserved.
//

import UIKit

final class ContainerViewController: UIViewController {
    
    fileprivate enum MenuState {
        case collapsed
        case expanded
    }
    
    private let menuWidthRatio: CGFloat = 0.7
    private let menuAnimationTreshold: CGFloat = 0.3
    
    private let menuViewController = MenuViewController.instantiate()
    private let baseViewController =  BaseViewController.instantiate()

    private lazy var baseNavigationController = UINavigationController(rootViewController: baseViewController)
    
    private var menuState: MenuState = .collapsed
    
    private var menuScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    private var menuPanGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseViewController.delegate = self
        
        setUpViews()
        setUpGestures()
    }
}

// MARK: - BaseViewController Delegate
extension ContainerViewController: BaseViewControllerDelegate {
    
    func menuButtonTapped() {
        let isCollapsed = (menuState == .collapsed)
        animateMenu(shouldExpand: isCollapsed)
    }
}

// MARK: - Menu Animation
private extension ContainerViewController {

    func setUpViews() {
        addChild(baseNavigationController)
        view.addSubview(baseNavigationController.view)
        baseNavigationController.didMove(toParent: self)
        
        addChild(menuViewController)
        view.insertSubview(menuViewController.view, at: 0)
        menuViewController.didMove(toParent: self)
        
        baseNavigationController.view.layer.shadowOpacity = 0.7
    }
    
    func animateMenu(shouldExpand: Bool) {
        if shouldExpand {
            animateBaseViewPosition(x: baseNavigationController.view.frame.width * menuWidthRatio) { _ in
                self.menuState = .expanded
                self.changeEnabledGesture(menuState: self.menuState)
            }
        } else {
            animateBaseViewPosition(x: 0) { _ in
                self.menuState = .collapsed
                self.changeEnabledGesture(menuState: self.menuState)
            }
        }
    }
    
    func animateBaseViewPosition(x: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.baseNavigationController.view.frame.origin.x = x
        }, completion: completion)
    }
}

// MARK: - Gesture Recognizers
private extension ContainerViewController {
    
    func setUpGestures() {
        menuScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        menuScreenEdgePanGestureRecognizer.edges = .left
        baseNavigationController.view.addGestureRecognizer(menuScreenEdgePanGestureRecognizer)
        
        menuPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        baseNavigationController.view.addGestureRecognizer(menuPanGestureRecognizer)
    }
    
    @objc func handleGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let recognizerView = recognizer.view else {
            return
        }
        
        let menuWidth = view.bounds.size.width * menuWidthRatio
        
        switch (menuState, recognizer.state) {
        case (_, .changed):
            let positionX = recognizerView.frame.origin.x + recognizer.translation(in: view).x
            if positionX < 0 {
                recognizerView.frame.origin.x = 0
            } else if menuWidth < positionX {
                recognizerView.frame.origin.x = menuWidth
            } else {
                recognizerView.frame.origin.x = positionX
            }
            recognizer.setTranslation(CGPoint.zero, in: view)
        case (.collapsed, .ended):
            let hasMovedGreaterThanTreshold =  menuWidth * menuAnimationTreshold < recognizerView.frame.origin.x
            animateMenu(shouldExpand: hasMovedGreaterThanTreshold)
        case (.expanded, .ended):
            let hasMovedLessThanTreshold = recognizerView.frame.origin.x < menuWidth * (1 - menuAnimationTreshold)
            animateMenu(shouldExpand: !hasMovedLessThanTreshold)
        default:
            break
        }
    }
    
    func changeEnabledGesture(menuState: MenuState) {
        switch menuState {
        case .collapsed:
            self.menuScreenEdgePanGestureRecognizer.isEnabled = true
            self.menuPanGestureRecognizer.isEnabled = false
        case .expanded:
            self.menuScreenEdgePanGestureRecognizer.isEnabled = false
            self.menuPanGestureRecognizer.isEnabled = true
        }
    }
}
