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
  public var duration: TimeInterval = 0.4
  /// The background's blur style. If nil, won't add blur effect.
  public var blurEffectStyle: UIBlurEffect.Style?
  
  // Helps figuring the distance views has moved to better handle a possible pan gesture.
  internal var transitionDistance: CGFloat = 0.0
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    // Check the integrity of context
    guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
      let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
      let originView = originalView,
      let destView = destinationView
      else {
        print("Transition has not been setup!")
        return
    }
    let containerView = transitionContext.containerView
    print("Easy Present")
    
    // Prepares the presented view before moving on.
    toVC.view.frame = transitionContext.finalFrame(for: toVC)
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
    
    let xTrans = abs(originalFrame.minX - destView.frame.minX)
    let yTrans = abs(originalFrame.minY - destView.frame.minY)
    transitionDistance = distance(of: CGPoint(x: xTrans, y: yTrans))
    
    destView.isHidden = true
    originView.isHidden = true
    
    // Add blur style, in case a blur style has been set.
    if let blurStyle = blurEffectStyle {
      let fromWholeSnapshot = fromVC.view.snapshot()
      let effectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
      effectView.frame = transitionContext.finalFrame(for: toVC)
      effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      effectView.addSubview(fromWholeSnapshot)      
      toVC.view.insertSubview(fromWholeSnapshot, at: 0)
      toVC.view.insertSubview(effectView, aboveSubview: fromWholeSnapshot)
  
    }
    
    // Adds views to container view to start animations.
    containerView.addSubview(toVC.view)
    containerView.addSubview(fromSnapshot)
    containerView.addSubview(toSnapshot)
    
    let duration = transitionDuration(using: transitionContext)
    
    // Animations will be handled with keyframe animations.
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubicPaced], animations: {
      
      // The move animation.
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
        fromSnapshot.frame = finalFrame
        toSnapshot.frame = finalFrame
        toVC.view.alpha = 1.0
      })
      
      // Fades source view to destination.
      UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {
        fromSnapshot.alpha = 0.0
        toSnapshot.alpha = 1.0
      })
      
    }) { _ in
      
      // Wrap up final state of the transition.
      destView.layoutIfNeeded()
      destView.isHidden = false
      originView.isHidden = false

      fromSnapshot.removeFromSuperview()
      toSnapshot.removeFromSuperview()
      
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
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
  public var duration: TimeInterval = 0.4

  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    // Check the integrity of context
    guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
      let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
      let originView = originalView,
      let destView = destinationView
      else {
        print("Transition has not been setup!")
        return
    }
    let containerView = transitionContext.containerView
    print("Easy Dismiss")
    // Prepare required info fro transitions.
    let finalFrame = destView.frame
    let originalFrame = originView.frame
    let fromSnapshot = originView.snapshotView(afterScreenUpdates: false)
    let toSnapshot = destView.snapshot()

    // Setup initial state of the snapshots and other views.
    fromSnapshot?.alpha = 1.0
    toSnapshot.alpha = 0.0
    fromVC.view.alpha = 1.0
    toVC.view.alpha = 1.0
    fromSnapshot?.frame = originalFrame
    toSnapshot.frame = originalFrame
    
    originView.isHidden = true
    destView.isHidden = true
    let fromWholeSnapshot = fromVC.view.snapshot()    
    
    // Add views to transition's container view.
    containerView.addSubview(toVC.view)
    containerView.addSubview(fromWholeSnapshot)
    containerView.addSubview(fromSnapshot!)
    containerView.addSubview(toSnapshot)

    let duration = transitionDuration(using: transitionContext)
    
    // Transition's animation will be handled using keyframe.
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubicPaced], animations: {
      
      // The move transition.
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
        fromSnapshot?.frame = finalFrame
        toSnapshot.frame = finalFrame
        
      })
      
      UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 3/4, animations: { 
        fromWholeSnapshot.alpha = 0.0        
      })
      
      // Fade animation from source to destination view.
      UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {
        fromSnapshot?.alpha = 0.0
        toSnapshot.alpha = 1.0
        fromVC.view.alpha = 0.0
      })
      
    }) { _ in
      
      // Wrap up final state of the transitions.
      destView.layoutIfNeeded()
      
      destView.isHidden = false
      originView.isHidden = false
      
      fromSnapshot?.removeFromSuperview()
      toSnapshot.removeFromSuperview()
      fromWholeSnapshot.removeFromSuperview()
      
      // For interactive dismissal, we need to know if the transition was cancelled and revert the effect of transition causing source view to be removed from container view.
      if transitionContext.transitionWasCancelled {
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
  public var duration: TimeInterval = 0.4
  
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    // Check the integrity of context
    guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
      let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
      let originView = originalView,
      let destView = destinationView
      else {
        print("Transition has not been setup!")
        return
    }
    let containerView = transitionContext.containerView
    print("Easy Pop")
    // Prepare required info fro transitions.
    let finalFrame = destView.frame
    let originalFrame = originView.frame
    let fromSnapshot = originView.snapshotView(afterScreenUpdates: false)
    let toSnapshot = destView.snapshot()

    // Setup initial state of the snapshots and other views.
    fromSnapshot?.alpha = 1.0
    toSnapshot.alpha = 0.0
    fromVC.view.alpha = 1.0
    toVC.view.alpha = 1.0
    fromSnapshot?.frame = originalFrame
    toSnapshot.frame = originalFrame
    
    originView.isHidden = true
    destView.isHidden = true
    let fromWholeSnapshot = fromVC.view.snapshot()
    
    // Add views to transition's container view.
    toVC.view.frame = toVC.view.frame.offsetBy(dx: -(toVC.view.frame.width / 3.0), dy: 0)
    containerView.addSubview(toVC.view)
    containerView.addSubview(fromWholeSnapshot)
    containerView.addSubview(fromSnapshot!)
    containerView.addSubview(toSnapshot)

    let duration = transitionDuration(using: transitionContext)
    
    // Transition's animation will be handled using keyframe.
    UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubicPaced], animations: {
      
      // The move transition.
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
        fromSnapshot?.frame = finalFrame
        toSnapshot.frame = finalFrame
        fromWholeSnapshot.frame = fromWholeSnapshot.frame.offsetBy(dx: fromWholeSnapshot.frame.width, dy: 0)
        toVC.view.frame.origin.x = 0
      })
      
      // Fade animation from source to destination view.
      UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {
        fromSnapshot?.alpha = 0.0
        toSnapshot.alpha = 1.0
        fromVC.view.alpha = 0.0
      })
      
    }) { _ in
      
      // Wrap up final state of the transitions.
      destView.layoutIfNeeded()
      
      destView.isHidden = false
      originView.isHidden = false
      
      fromSnapshot?.removeFromSuperview()
      toSnapshot.removeFromSuperview()
      fromWholeSnapshot.removeFromSuperview()
      
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
  }
  
}

/// Handles Interactive dismissal of Modally presented controllers.
public class EasyInteractiveAnimationController: UIPercentDrivenInteractiveTransition {
  
  /// Determines whether this instance is interactively dismissing a controller.
  var isInteracting = false
  /// The amount of pixels user has to pan in order to dismiss the controller. (more than half would be conidered good enough)
  var panDistance: CGFloat = 200
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
  @objc private func handle(_ gesture: UIPanGestureRecognizer) {

    guard let superView = gesture.view?.superview else {
      print("Gesture's not been correctly setup")
      return
    }
  
    guard panDistance != 0 else {
      print("panLength cannot be 0!")
      return
    }
    
    let translation = gesture.translation(in: superView)
    var progress: CGFloat = distance(of: translation) / panDistance
    progress = min(max(progress, 0.0), 1.0)
    
    switch gesture.state {
    
    case .began:
    isInteracting = true
      targetController.dismiss(animated: true, completion: nil)
    case .changed:
      shouldFinish = progress > 0.5
      update(progress)
    case .ended:
      
      isInteracting = false
      if !shouldFinish {
        cancel()
      } else {
        finish()
      }
    case .cancelled:
      isInteracting = false
      cancel()
    default:
      print("Gesture state invalid!")
      return
    }
    
  }
  
}

internal func distance(of translation: CGPoint) -> CGFloat {
  return hypot(translation.x, translation.y)
}

// A handy extension to allow snapshotting views. Because UIView's snapshot method messes up auto-layout.
internal extension UIView {
  func snapshot() -> UIImageView {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
    layer.render(in: UIGraphicsGetCurrentContext()!)    
    let img = UIGraphicsGetImageFromCurrentImageContext()
    
    return UIImageView(image: img)
    
  }
}

