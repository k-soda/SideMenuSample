//
//  MenuHelper.swift
//  SideMenuSample
//
//  Created by KS on 2018/12/10.
//  Copyright © 2018 KS. All rights reserved.
//

import Foundation
import UIKit

enum Direction {
    case right
    case left
}

struct MenuHelper {
    
    static let menuWidth = CGFloat(0.7)
    static let percentThreshold = CGFloat(0.3)
    static let snapshotTag = 999
    
    static func calculateProgress(translationInView: CGPoint, viewBounds: CGRect, direction: Direction) -> CGFloat {
        let movementOnAxis = translationInView.x / viewBounds.width
        
        switch direction {
        case .right:
            let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
            let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
            return CGFloat(positiveMovementOnAxisPercent)
        case .left:
            let positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
            let positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
            return CGFloat(-positiveMovementOnAxisPercent)
        }
    }
    
    static func mapGestureStateToInteractor(gestureState: UIGestureRecognizer.State, progress: CGFloat, interactor: Interactor?, triggerTransition: () -> Void) {
        guard let interactor = interactor else {
            return
        }
        
        switch gestureState {
        case .began:
            interactor.hasStarted = true
            triggerTransition()
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
    }
}
