//
//  UIViewController+TransEasy.swift
//  TransEasy
//
//  Created by Mohammad Porooshani on 7/21/16.
//  Copyright © 2016 Porooshani. All rights reserved.
//

import UIKit

var PresentAssociatedHandler: UInt8 = 0

public struct EasyTransPresentOptions {
  var duration: NSTimeInterval = 0.4
  let sourceView: UIView
//  let destinationView: UIView
  var blurStyle: UIBlurEffectStyle?
}

public struct EasyTransDismissOptions {
  
  var duration: NSTimeInterval = 0.4
//  let sourceView: UIView
  let destinationView: UIView
}

public extension UIViewController {
  
  
  internal var easyTransDelegate: EasyPresentHelper? {
    get {
      return objc_getAssociatedObject(self, &PresentAssociatedHandler) as? EasyPresentHelper
    }
    
    set {
      objc_setAssociatedObject(self, &PresentAssociatedHandler, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      
    }
  }
  

  func setupEasyTransition(on targetViewController: UIViewController, presentOptions: EasyTransPresentOptions?, dismissOptions: EasyTransDismissOptions?) {
    
    let transDel = EasyPresentHelper(presentOptions: presentOptions, dismissOptions: dismissOptions)
    easyTransDelegate = transDel
    targetViewController.transitioningDelegate = easyTransDelegate
    
  }
  
}

class EasyPresentHelper: NSObject, UIViewControllerTransitioningDelegate {
  
  lazy var presentAnimator = EasyPresentAnimationController()
  lazy var dismissAnimator = EasyDismissAnimationController()
  
  let presentOptions: EasyTransPresentOptions?
  let dismissOptions: EasyTransDismissOptions?
  
  init(presentOptions: EasyTransPresentOptions?, dismissOptions: EasyTransDismissOptions?) {
    self.presentOptions = presentOptions
    self.dismissOptions = dismissOptions
  }

  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    guard let pOptions = presentOptions,
    let pDestPro = presented as? EasyTransDestinationViewControllerProtocol
      else {
      return nil
    }

    presentAnimator.blurEffectStyle = pOptions.blurStyle
    presentAnimator.duration = pOptions.duration
    presentAnimator.originalView = pOptions.sourceView
    presentAnimator.destinationView = pDestPro.destinationView()
    
    return presentAnimator
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    guard let dOption = dismissOptions,
    let sDestPro = dismissed as? EasyTransDestinationViewControllerProtocol
    else {
      return nil
    }
    dismissAnimator.duration = dOption.duration
    dismissAnimator.originalView = sDestPro.destinationView()
    dismissAnimator.destinationView = dOption.destinationView
    
    return dismissAnimator
    
  }
  
  
}

public protocol EasyTransDestinationViewControllerProtocol {
  
  func destinationView() -> UIView
  
}
