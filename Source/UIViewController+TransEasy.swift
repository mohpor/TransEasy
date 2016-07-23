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

var PresentAssociatedHandler: UInt8 = 0

public struct EasyTransPresentOptions {
  public var duration: NSTimeInterval = 0.4
  public let sourceView: UIView
  public let blurStyle: UIBlurEffectStyle?
  
  public init(duration: NSTimeInterval, sourceView: UIView, blurStyle: UIBlurEffectStyle? = nil) {
    self.duration = duration
    self.sourceView = sourceView
    self.blurStyle = blurStyle
  }
}

public struct EasyTransDismissOptions {
  
  public var duration: NSTimeInterval = 0.4
  public let destinationView: UIView
  
  public init(duration: NSTimeInterval, destinationView: UIView) {
    self.duration = duration
    self.destinationView = destinationView
  }
  
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
