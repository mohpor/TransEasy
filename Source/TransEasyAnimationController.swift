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
  var blurEffectStyle: UIBlurEffectStyle?
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    // Check the integrity of context
    guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
      let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
      let containerView = transitionContext.containerView(),
      let originView = originalView,
      let destView = destinationView
      else {
        print("Transition has not been setup!")
        return
    }
    
    
    
    toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    toVC.view.setNeedsDisplay()
    toVC.view.layoutIfNeeded()
    
    
    let finalFrame = destView.frame
    let originalFrame = originView.frame
    let fromSnapshot = UIImageView(image: originView.snapshot()) //originView.snapshotViewAfterScreenUpdates(false)
    
    let toSnapshot = UIImageView.init(image: destView.snapshot())
    
    fromSnapshot.alpha = 1.0
    toSnapshot.alpha = 0.0
    toVC.view.alpha = 0.0
    
    
    fromSnapshot.frame = originalFrame
    toSnapshot.frame = originalFrame
    
    destView.hidden = true
    originView.hidden = true
    
    
    if let blurStyle = blurEffectStyle {
      let fromWholeSnapshot = UIImageView(image: fromVC.view.snapshot())
      let effectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
      effectView.frame = transitionContext.finalFrameForViewController(toVC)
      effectView.addSubview(fromWholeSnapshot)
      toVC.view.insertSubview(fromWholeSnapshot, atIndex: 0)
      toVC.view.insertSubview(effectView, aboveSubview: fromWholeSnapshot)
  
    }
    
    
    containerView.addSubview(toVC.view)
    containerView.addSubview(fromSnapshot)
    containerView.addSubview(toSnapshot)
    
    
    
    let duration = transitionDuration(transitionContext)
    
    UIView.animateKeyframesWithDuration(duration, delay: 0, options: [.CalculationModeCubicPaced], animations: {
      
      UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: {
        fromSnapshot.frame = finalFrame
        toSnapshot.frame = finalFrame
        toVC.view.alpha = 1.0
      })
      
      UIView.addKeyframeWithRelativeStartTime(1/2, relativeDuration: 1/2, animations: {
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

class EasyDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  var originalView: UIView?
  var destinationView: UIView?
  var duration: NSTimeInterval = 0.6
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    // Check the integrity of context
    guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
      let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
      let containerView = transitionContext.containerView(),
      let originView = originalView,
      let destView = destinationView
      else {
        print("Transition has not been setup!")
        return
    }    
    
    let finalFrame = destView.frame
    let originalFrame = originView.frame
    let fromSnapshot = originView.snapshotViewAfterScreenUpdates(false)
    let toSnapshot = UIImageView.init(image: destView.snapshot())
    
    
    fromSnapshot.alpha = 1.0
    toSnapshot.alpha = 0.0
    
    fromVC.view.alpha = 1.0
    toVC.view.alpha = 1.0
    
    fromSnapshot.frame = originalFrame
    toSnapshot.frame = originalFrame
    
    originView.hidden = true
    destView.hidden = true
    let fromWholeSnapshot = UIImageView(image: fromVC.view.snapshot())    
    
    containerView.addSubview(toVC.view)
    containerView.addSubview(fromWholeSnapshot)
    containerView.addSubview(fromSnapshot)
    containerView.addSubview(toSnapshot)

    
    
    
    let duration = transitionDuration(transitionContext)
    
    UIView.animateKeyframesWithDuration(duration, delay: 0, options: [.CalculationModeCubicPaced], animations: {
      
      UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: {
        fromSnapshot.frame = finalFrame
        toSnapshot.frame = finalFrame
        fromWholeSnapshot.alpha = 0.0
      })
      
      UIView.addKeyframeWithRelativeStartTime(1/2, relativeDuration: 1/2, animations: {
        fromSnapshot.alpha = 0.0
        toSnapshot.alpha = 1.0
      })
      
    }) { _ in
      destView.layoutIfNeeded()
      
      destView.hidden = false
      originView.hidden = false
      
      fromSnapshot.removeFromSuperview()
      toSnapshot.removeFromSuperview()
      fromWholeSnapshot.removeFromSuperview()
      
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
    
    
  }
  
  
}

private extension UIView {
  func snapshot() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    layer.renderInContext(UIGraphicsGetCurrentContext()!)
    
    let img = UIGraphicsGetImageFromCurrentImageContext()
    return img
    
  }
}
