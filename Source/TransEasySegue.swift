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

/// A custom segue for EasyTrans animations.
public class TransEasySegue: UIStoryboardSegue {
  
  /// The source view of the transition. (For TransEasy transitions.)
  var sourceView: UIView?
  
  override public func perform() {
    
    // Keeping the original frame of the source controller for later use.
    let sourceOriginalFrame = source.view.frame
    // Starts the actual transition, to generate the required info. We will take control of the transition later on.
    super.perform()
    
    // Find strong references to required objects, or bail on the transitioning if need be.
    guard let transitionCoorrdinator = destination.transitionCoordinator,
    let secondVC = destination as? TransEasyDestinationViewControllerProtocol,
    let sourceV = sourceView ?? (source as? TransEasyDestinationViewControllerProtocol)?.transEasyDestinationView()
    else {
      // In case something is wrong with the transition, we will perform an appropriate transition animation just in case.
      print("Segue is not correctly prepared!")
      if let navControl = source.navigationController {
      navControl.pushViewController(destination, animated: true)
      } else {
        source.present(destination, animated: true, completion: nil)
      }
      return
    }
    
    // Initalizes The view for the destination view controller. (Interestingly enough, this method will cause the destination view controller to be initialized too! should prevent from calling it, because it is causing double instantiations.)
    destination.view.layoutIfNeeded()
    
    let destV = secondVC.transEasyDestinationView()
    let containerView = transitionCoorrdinator.containerView
    
    let originalFrame = sourceV.frame
    let destinationFrame = destV.frame

    let sourceSnapshot = sourceV.snapshot()
    sourceSnapshot.frame = originalFrame
    
    let destinationSnapshot = destV.snapshot()
    destinationSnapshot.frame = originalFrame
    destinationSnapshot.alpha = 0.0
    
    // Hide original views, while we work on snapshots.
    destV.isHidden = true
    sourceV.isHidden = true
    
    let sourceFullSnap = source.view.snapshot()
    sourceFullSnap.frame = sourceOriginalFrame
    
    containerView.addSubview(sourceFullSnap)
    source.view.isHidden = true
    
    // The order of these insertions are important, because that will be the way they are being rendered on top of each other.
    containerView.insertSubview(sourceSnapshot, aboveSubview: sourceFullSnap)
    containerView.insertSubview(destinationSnapshot, aboveSubview: sourceSnapshot)

    // This is where we start to animate alongside the tranition coordinator.
    transitionCoorrdinator.animate(alongsideTransition: { (context) in

      containerView.bringSubviewToFront(destinationSnapshot)
      containerView.bringSubviewToFront(sourceSnapshot)
      
      sourceFullSnap.frame = self.source.view.convert(self.source.view.frame, to: containerView)
      
      sourceSnapshot.frame = destinationFrame
      destinationSnapshot.frame = destinationFrame
      
      sourceSnapshot.alpha = 0.0
      destinationSnapshot.alpha = 1.0
      
      }) { (context) in
        
        sourceSnapshot.removeFromSuperview()
        sourceFullSnap.removeFromSuperview()
        destinationSnapshot.removeFromSuperview()
        destV.isHidden = false
        sourceV.isHidden = false
        self.source.view.isHidden = false
        
    }
    
  }
  
}

