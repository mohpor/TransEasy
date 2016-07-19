//
//  EasyPresentAnimationController.swift
//  TransEasy
//
//  Created by Mohammad on 7/19/16.
//  Copyright © 2016 Porooshani. All rights reserved.
//

import UIKit

class EasyPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  var originalView: UIView?
  var destinationView: UIView?
  var duration: NSTimeInterval = 0.6
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    // Check the integrity of context
    guard
      let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
      let containerView = transitionContext.containerView(),
      let originView = originalView,
      let destView = destinationView
      else {
        print("Transition has not been setup!")
        return
    }
    
    toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    toVC.view.layoutIfNeeded()
    
    let finalFrame = destView.frame
    
    let fromSnapshot = originView.snapshotViewAfterScreenUpdates(true)
    let toSnapshot = destView.snapshotViewAfterScreenUpdates(true)
    
    fromSnapshot.alpha = 1.0
    toSnapshot.alpha = 0.0
    toVC.view.alpha = 0.0
    
    
    toSnapshot.frame = fromSnapshot.frame
    destView.hidden = true
    originView.hidden = true
    
    containerView.addSubview(fromSnapshot)
    containerView.insertSubview(toSnapshot, belowSubview: fromSnapshot)
    containerView.addSubview(toVC.view)
    
    
    let duration = transitionDuration(transitionContext)
    
    UIView.animateKeyframesWithDuration(duration, delay: 0, options: .CalculationModeCubic, animations: {
      
      UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: {
        fromSnapshot.frame = finalFrame
        toSnapshot.frame = finalFrame
        toVC.view.alpha = 1.0
      })
      
      UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 2/3, animations: { 
        fromSnapshot.alpha = 0.0
        toSnapshot.alpha = 1.0
      })      
      
    }) { _ in
      destView.layoutIfNeeded()
      
      destView.hidden = false
      originView.hidden = false
      
      fromSnapshot.removeFromSuperview()
      toSnapshot.removeFromSuperview()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
    
    
  }
  
  
}
