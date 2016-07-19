//
//  FirstViewController.swift
//  TransEasy
//
//  Created by Mohammad on 7/19/16.
//  Copyright © 2016 Porooshani. All rights reserved.
//

import UIKit

private let toSecondViewSegueID = "toSecondViewSegue"

class FirstViewController: UIViewController {

    @IBOutlet weak var qrButton: UIButton!
  
    var easyPresentAnimationComtroller = EasyPresentAnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func qrButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier(toSecondViewSegueID, sender: sender)        
    }
  
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    guard let segueID = segue.identifier else {
      print("Could not verify the segue's identity")
      return
    }
    
    switch segueID {
    case toSecondViewSegueID:
      segue.destinationViewController.transitioningDelegate = self      
    default:
      print("Unknown segue!")
    }
    
  }

}


extension FirstViewController: UIViewControllerTransitioningDelegate {
  
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
   
    guard let secondVC = presented as? SecondViewController else {
      print("Invalid target controller")
      return nil
    }
    
    easyPresentAnimationComtroller.originalView = qrButton
    easyPresentAnimationComtroller.destinationView = secondVC.qiImage

    return easyPresentAnimationComtroller
  }
  
}
