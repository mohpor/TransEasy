//
//  UIViewController+TransEasy.swift
//  TransEasy
//
//  Created by Mohammad Porooshani on 7/25/16.
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

public class TransEasySegue: UIStoryboardSegue {
  
   var sourceView: UIView?
  
  override public func perform() {
    
    let sourceOriginalFrame = sourceViewController.view.frame
    
    super.perform()
    
    guard let transitionCoorrdinator = destinationViewController.transitionCoordinator(),
    secondVC = destinationViewController as? TransEasyDestinationViewControllerProtocol,
    sourceV = sourceView ?? (sourceViewController as? TransEasyDestinationViewControllerProtocol)?.transEasyDestinationView()
    else {
      print("Segue is not correctly prepared!")
      if let navControl = sourceViewController.navigationController {
      navControl.pushViewController(destinationViewController, animated: true)
      } else {
        sourceViewController.presentViewController(destinationViewController, animated: true, completion: nil)
      }
      return
    }
    
    
    destinationViewController.view.layoutIfNeeded()
    
    let destV = secondVC.transEasyDestinationView()
    let containerView = transitionCoorrdinator.containerView()
    
    let originalFrame = sourceV.frame
    let destinationFrame = destV.frame

    let sourceSnapshot = sourceV.snapshot()
    sourceSnapshot.frame = originalFrame
    
    let destinationSnapshot = destV.snapshot()
    destinationSnapshot.frame = originalFrame
    destinationSnapshot.alpha = 0.0
    
    
    destV.hidden = true
    sourceV.hidden = true
    
    let sourceFullSnap = sourceViewController.view.snapshot()
    sourceFullSnap.frame = sourceOriginalFrame
    
    containerView.addSubview(sourceFullSnap)
    sourceViewController.view.hidden = true  
    
    
    containerView.insertSubview(sourceSnapshot, aboveSubview: sourceFullSnap)
    containerView.insertSubview(destinationSnapshot, aboveSubview: sourceSnapshot)

    transitionCoorrdinator.animateAlongsideTransition({ (context) in

      containerView.bringSubviewToFront(destinationSnapshot)
      containerView.bringSubviewToFront(sourceSnapshot)

      
      sourceFullSnap.frame = self.sourceViewController.view.convertRect(self.sourceViewController.view.frame, toView: containerView)
      
      sourceSnapshot.frame = destinationFrame
      destinationSnapshot.frame = destinationFrame
      
      sourceSnapshot.alpha = 0.0
      destinationSnapshot.alpha = 1.0
      
      }) { (context) in
        
        sourceSnapshot.removeFromSuperview()
        sourceFullSnap.removeFromSuperview()
        destinationSnapshot.removeFromSuperview()
        destV.hidden = false
        sourceV.hidden = false
        self.sourceViewController.view.hidden = false
        
    }
    
    
  }
  
}

