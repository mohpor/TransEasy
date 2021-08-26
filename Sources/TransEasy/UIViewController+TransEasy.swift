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

/// Holds a reference to the memory for associated delegate object.
var presentAssociatedHandler: UInt8 = 0

/**
 *  A simple struct to encapsulate present transition's settings.
 *  This struct is used only if you use the UIViewController's extension related to TransEasy.
 */
public struct TransEasyPresentOptions {
  /// The duration of the animation.
  public var duration: TimeInterval = 0.4
  /// The view present will start from.
  public let sourceView: UIView
  /// The blur effect to use as background. (If set as nil, won't add blur effect)
  public let blurStyle: UIBlurEffect.Style?

  public init(duration: TimeInterval, sourceView: UIView, blurStyle: UIBlurEffect.Style? = nil) {
    self.duration = duration
    self.sourceView = sourceView
    self.blurStyle = blurStyle
  }
}

/**
 *  A simple struct to encapsulate dismiss transition's settings.
 *  This struct is used only if you use the UIViewController's extension related to TransEasy.
 */
public struct TransEasyDismissOptions {
  /// The duration of the animation.
  public var duration: TimeInterval = 0.4
  /// The view dismiss transition animation will end on.
  public let destinationView: UIView
  /**
   Indicates the dismiss action could be interactive.
   - Please be advised that this is a simple suggestion. FOr now, if the presentation style is not modal (push, replace, etc...) this will not add an interactive dismissal.
   */
  public var interactive = false
  
  public init(duration: TimeInterval, destinationView: UIView, interactive: Bool = false) {
    self.duration = duration
    self.destinationView = destinationView
    self.interactive = interactive
  }
  
}

public extension UIViewController {
  
  /// The reference to the animator object. The `transitioningDelegate` of the `UIViewController` is of weak type therefore ot will be lost after setup.
  internal var easyTransDelegate: EasyPresentHelper? {
    get {
      return objc_getAssociatedObject(self, &presentAssociatedHandler) as? EasyPresentHelper
    }
    
    set {
      objc_setAssociatedObject(self, &presentAssociatedHandler, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      
    }
  }
  
  /**
   Allows the view controller to have an easy transition from a view controller to another view controller, moving a view in between.
   
   - parameter targetViewController: The destination of the transition. If you are using a segue, this is the actual `destinationViewController` of the segue.
   - parameter presentOptions:       The options for present animation.
   - parameter dismissOptions:       The options for dimiss animation.
   
   - discussion `targetViewController` should implement `TransEasyDestinationViewControllerProtocol`, because in `prepareForSegue` views are not yet initialized and you wouldn't have access to view's references.
   
   */
  func setupEasyTransition(on targetViewController: UIViewController, presentOptions: TransEasyPresentOptions?, dismissOptions: TransEasyDismissOptions?) {
    
    let transDel = EasyPresentHelper(presentOptions: presentOptions, dismissOptions: dismissOptions)

    easyTransDelegate = transDel

    if true == dismissOptions?.interactive {
      transDel.interactiveAnimator.attach(to: targetViewController)
    }
    
    targetViewController.transitioningDelegate = easyTransDelegate
    self.navigationController?.delegate = transDel
    
  }
 
  /**
   Determines if the presentatin is modal.
   
   - returns: true if is modally presented, false otherwise.
   */
  func isModal() -> Bool {
    if self.presentingViewController != nil {
      return true
    }
    
    if self.presentingViewController?.presentedViewController == self {
      return true
    }
    
    if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
      return true
    }
    
    if self.tabBarController?.presentingViewController is UITabBarController {
      return true
    }
    
    return false
  }
}

/// A class that will act as animation controller for the view controllers.
class EasyPresentHelper: NSObject, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
  
  /// A lazy instance of `EasyPresentAnimationController` that will hold on to present animation controller.
  lazy var presentAnimator = EasyPresentAnimationController()
  /// A lazy instance of `EasyDismissAnimationController` that will hold on to dimiss animation controller.
  lazy var dismissAnimator = EasyDismissAnimationController()
  /// A lazy instance of `EasyPopAnimationController` that will hold on to pop animation.
  lazy var popAnimator = EasyPopAnimationController()
  /// A lazy `EasyInteractiveAnimationController` that will hold on to an interactive animation controller.
  lazy var interactiveAnimator = EasyInteractiveAnimationController()
  /// The present options.
  let presentOptions: TransEasyPresentOptions?
  /// The dismiss options.
  let dismissOptions: TransEasyDismissOptions?
  
  init(presentOptions: TransEasyPresentOptions?, dismissOptions: TransEasyDismissOptions?) {
    self.presentOptions = presentOptions
    self.dismissOptions = dismissOptions
  }

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

    /// If setup is not complete, this method will return nil allowing UIKit to use the default transition.
    guard let pOptions = presentOptions,
      let pDestPro = presented as? TransEasyDestinationViewControllerProtocol
      else {
        return nil
    }

    // Setup animator's settings.
    presentAnimator.blurEffectStyle = pOptions.blurStyle
    presentAnimator.duration = pOptions.duration
    presentAnimator.originalView = pOptions.sourceView
    presentAnimator.destinationView = pDestPro.transEasyDestinationView()

    return presentAnimator

  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    /// If setup is not complete, this method will return nil allowing UIKit to use the default transition.
    guard let dOption = dismissOptions,
    let sDestPro = dismissed as? TransEasyDestinationViewControllerProtocol
    else {
      return nil
    }
    
    // Setup animator's settings.
    dismissAnimator.duration = dOption.duration
    dismissAnimator.originalView = sDestPro.transEasyDestinationView()
    dismissAnimator.destinationView = dOption.destinationView
    
    return dismissAnimator
    
  }

  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    
    interactiveAnimator.panDistance = presentAnimator.transitionDistance == 0.0 ? 200.0 : presentAnimator.transitionDistance
    return interactiveAnimator.isInteracting ? interactiveAnimator : nil
    
  }

  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    guard operation == .pop else {
      return nil
    }
    
    /// If setup is not complete, this method will return nil allowing UIKit to use the default transition.
    guard let dOption = dismissOptions,
      let sDestPro = fromVC as? TransEasyDestinationViewControllerProtocol
      else {
        return nil
    }
    
    // Setup animator's settings.
    popAnimator.duration = dOption.duration
    popAnimator.originalView = sDestPro.transEasyDestinationView()
    popAnimator.destinationView = dOption.destinationView

    return popAnimator
    
  }
}

/**
 *  A simple protocol that will be used instead of a property, to let the destination view be selected lazily.
 */
public protocol TransEasyDestinationViewControllerProtocol {
  
  /**
   The View that transition will finish on. Please note that this method can be used for dismiss options as well.
   
   - returns: A UIView that will be used at final view (or initial view for dimiss) transition.
   */
  func transEasyDestinationView() -> UIView
  
}
