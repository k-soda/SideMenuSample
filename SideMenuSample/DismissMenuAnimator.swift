//
//  DismissMenuAnimator.swift
//  SideMenuSample
//
//  Created by KS on 2018/12/10.
//  Copyright © 2018 KS. All rights reserved.
//

import UIKit

final class DismissMenuAnimator: NSObject {}

extension DismissMenuAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let animationDuration = transitionDuration(using: transitionContext)
        
        guard let snapshot = containerView.viewWithTag(MenuHelper.snapshotTag),
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            snapshot.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        }, completion: { _ in
            let didTransitionComplete = !transitionContext.transitionWasCancelled
            if didTransitionComplete {
                containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
                snapshot.removeFromSuperview()
            }
            transitionContext.completeTransition(didTransitionComplete)
        })
    }
}
