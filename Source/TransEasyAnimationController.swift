//
//  UIViewController+TransEasy.swift
//  TransEasy
//
//  Created by Mohammad Porooshani on 7/21/16.
//  Copyright © 2016 Porooshani. All rights reserved.
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Mohammad Poroushani
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

/// Handles animations reqired for the TransEasy Present.
public class EasyPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  /// The view animation would use as starting point.
  public var originalView: UIView?
  /// The view that originalView will land to.
  public var destinationView: UIView?
  /// The duration of animation.
  public var duration: NSTimeInterval = 0.4
  /// The background's blur style. If nil, won't add blur effect.
  public var blurEffectStyle: UIBlurEffectStyle?
  
  
  public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }
  
  public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    // Check the integrity of context
    guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
      toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
      containerView = transitionContext.containerView(),
      originView = originalView,
      destView = destinationView
      else {
        print("Transition has not been setup!")
        return
    }

    // Prepares the presented view before moving on.
    toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    toVC.view.setNeedsDisplay()
    toVC.view.layoutIfNeeded()
    
    // Prepares required snapshots.
    let finalFrame = destView.frame
    let originalFrame = originView.frame
    let fromSnapshot = originView.snapshot()
    let toSnapshot = destView.snapshot()
    
    // Setup snapshot states before starting animations.
    fromSnapshot.alpha = 1.0
    toSnapshot.alpha = 0.0
    toVC.view.alpha = 0.0
    
    fromSnapshot.frame = originalFrame
    toSnapshot.frame = originalFrame
    
    destView.hidden = true
    originView.hidden = true
    
    // Add blur style, in case a blur style has been set.
    if let blurStyle = blurEffectStyle {
      let fromWholeSnapshot = fromVC.view.snapshot()
      let effectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
      effectView.frame = transitionContext.finalFrameForViewController(toVC)
      effectView.addSubview(fromWholeSnapshot)
      toVC.view.insertSubview(fromWholeSnapshot, atIndex: 0)
      toVC.view.insertSubview(effectView, aboveSubview: fromWholeSnapshot)
  
    }
    
    // Adds views to container view to start animations.
    containerView.addSubview(toVC.view)
    containerView.addSubview(fromSnapshot)
    containerView.addSubview(toSnapshot)

    
    let duration = transitionDuration(transitionContext)
    
    // Animations will be handled with keyframe animations.
    UIView.animateKeyframesWithDuration(duration, delay: 0, options: [.CalculationModeCubicPaced], animations: {
      
      // The move animation.
      UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: {
        fromSnapshot.frame = finalFrame
        toSnapshot.frame = finalFrame
        toVC.view.alpha = 1.0
      })
      
      // Fades source view to destination.
      UIView.addKeyframeWithRelativeStartTime(1/2, relativeDuration: 1/2, animations: {
        fromSnapshot.alpha = 0.0
        toSnapshot.alpha = 1.0
      })
      
    }) { _ in
      
      // Wrap up final state of the transition.
      destView.layoutIfNeeded()
      destView.hidden = false
      originView.hidden = false

      fromSnapshot.removeFromSuperview()
      toSnapshot.removeFromSuperview()
      
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
    
    
  }

  
}

/// Handles animations reqired for the TransEasy Dismiss.
public class EasyDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  // The source view dimiss transition starts from.
  public var originalView: UIView?
  // The view that dimiss will land to.
  public var destinationView: UIView?
  // Transitions duration.
  public var duration: NSTimeInterval = 0.4
  
  public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return duration
  }
  
  public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    // Check the integrity of context
    guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
      toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
      containerView = transitionContext.containerView(),
      originView = originalView,
      destView = destinationView
      else {
        print("Transition has not been setup!")
        return
    }    
    
    // Prepare required info fro transitions.
    let finalFrame = destView.frame
    let originalFrame = originView.frame
    let fromSnapshot = originView.snapshotViewAfterScreenUpdates(false)
    let toSnapshot = destView.snapshot()
    
    
    // Setup initial state of the snapshots and other views.
    fromSnapshot.alpha = 1.0
    toSnapshot.alpha = 0.0
    fromVC.view.alpha = 1.0
    toVC.view.alpha = 1.0
    fromSnapshot.frame = originalFrame
    toSnapshot.frame = originalFrame
    
    originView.hidden = true
    destView.hidden = true
    let fromWholeSnapshot = fromVC.view.snapshot()    
    
    // Add views to transition's container view.
    containerView.addSubview(toVC.view)
    containerView.addSubview(fromWholeSnapshot)
    containerView.addSubview(fromSnapshot)
    containerView.addSubview(toSnapshot)

    
    let duration = transitionDuration(transitionContext)
    
    // Transition's animation will be handled using keyframe.
    UIView.animateKeyframesWithDuration(duration, delay: 0, options: [.CalculationModeCubicPaced], animations: {
      
      // The move transition.
      UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1, animations: {
        fromSnapshot.frame = finalFrame
        toSnapshot.frame = finalFrame
        fromWholeSnapshot.alpha = 0.0
      })
      
      // Fade animation from source to destination view.
      UIView.addKeyframeWithRelativeStartTime(1/2, relativeDuration: 1/2, animations: {
        fromSnapshot.alpha = 0.0
        toSnapshot.alpha = 1.0
      })
      
    }) { _ in
      
      // Wrap up final state of the transitions.
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

// A handy extension to allow snapshotting views. Because UIView's snapshot method messes up auto-layout.
internal extension UIView {
  func snapshot() -> UIImageView {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    layer.renderInContext(UIGraphicsGetCurrentContext()!)    
    let img = UIGraphicsGetImageFromCurrentImageContext()
    
    return UIImageView(image: img)
    
  }
}
