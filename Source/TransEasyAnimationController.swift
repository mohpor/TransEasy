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
  
  // Helps figuring the distance views has moved to better handle a possible pan gesture.
  internal var translation: CGFloat = 0.0
  
  // Indicates the translation is more horizontal or verticall. (will be replaced with diagonal distance soon.)
  internal var horizontal = true
  
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

    print("Easy Present")
    
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
    
    let xTrans = fabs(originalFrame.minX - destView.frame.minX)
    let yTrans = fabs(originalFrame.minY - destView.frame.minY)
    
    if xTrans > yTrans {
      translation = xTrans
      horizontal = true
      
    } else {
      translation = yTrans
      horizontal = false
    }
    
    
    destView.hidden = true
    originView.hidden = true
    
    // Add blur style, in case a blur style has been set.
    if let blurStyle = blurEffectStyle {
      let fromWholeSnapshot = fromVC.view.snapshot()
      let effectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
      effectView.frame = transitionContext.finalFrameForViewController(toVC)
      effectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
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
    print("Easy Dismiss")
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
        
      })
      
      UIView.addKeyframeWithRelativeStartTime(1/4, relativeDuration: 3/4, animations: { 
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
      
      // For interactive dismissal, we need to know if the transition was cancelled and revert the effect of transition causing source view to be removed from container view.
      if transitionContext.transitionWasCancelled() {
        containerView.addSubview(fromVC.view)
        transitionContext.completeTransition(false)
      } else {
        transitionContext.completeTransition(true)
      }
      
    }
    
    
  }
  
  
}

public class EasyPopAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  
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
    print("Easy Pop")
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
    toVC.view.frame = toVC.view.frame.offsetBy(dx: -(toVC.view.frame.width / 3.0), dy: 0)
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
        fromWholeSnapshot.frame = fromWholeSnapshot.frame.offsetBy(dx: fromWholeSnapshot.frame.width, dy: 0)
        toVC.view.frame.origin.x = 0
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


/// Handles Interactive dismissal of Modally presented controllers.
public class EasyInteractiveAnimationController: UIPercentDrivenInteractiveTransition {
  
  /// Determines whether this instance is interactively dismissing a controller.
  var isInteracting = false
  /// The amount of pixels user has to pan in order to dismiss the controller. (more than half would be conidered good enough)
  var panLength: CGFloat = 200
  /// Determines whther the gesture should consider orizontal distance or vertical (Will be removed soon.)
  var horizontalGesture = true
  /// Determines whether the transition must be finalized (If not cancelled or left before the good enough point in interaction.)
  private var shouldFinish = false
  /// The view controller to add the interactive dismissal on.
  private weak var targetController: UIViewController!

  /**
   Applies interactive dismissal to a view controller. uses the view's parameter for gesture recognizer.
   
   - parameter controller: the controller to add interactive dismissal to.
   */
  public func attach(to controller: UIViewController) {
    targetController = controller
    prepareGesture(for: controller.view)
  }
  
  /**
   Prepares the required gestures to handle percent driven interactive transitions.
   
   - parameter view: The view to add the gesture to.
   - Currently, we are using pan gesture to handle the touch events.
   */
  private func prepareGesture(for view: UIView) {
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(handle(_:)))
    view.addGestureRecognizer(gesture)
  }
  
  /**
   Handles the gesture's state change to update the transition's progress.
   
   - parameter gesture: The gesture events happened on.
   */
  @objc private func handle(gesture: UIPanGestureRecognizer) {
    
    
    guard let superView = gesture.view?.superview else {
      print("Gesture's not been correctly setup")
      return
    }
  
    guard panLength != 0 else {
      print("panLength cannot be 0!")
      return
    }
    
    let translation = gesture.translationInView(superView)
    var progress: CGFloat = fabs(((horizontalGesture ? translation.x : translation.y) / panLength))
    progress = min(max(progress, 0.0), 1.0)
    
    switch gesture.state {
    
    case .Began:
    isInteracting = true
      targetController.dismissViewControllerAnimated(true, completion: nil)
    case .Changed:
      shouldFinish = progress > 0.5
      updateInteractiveTransition(progress)
    case .Ended:
      
      isInteracting = false
      if !shouldFinish {
        cancelInteractiveTransition()
      } else {
        finishInteractiveTransition()
      }
    case .Cancelled:
      isInteracting = false
      cancelInteractiveTransition()
    default:
      print("Gesture state invalid!")
      return
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

