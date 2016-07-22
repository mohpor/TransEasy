//
//  FirstViewController.swift
//  TransEasy
//
//  Created by Mohammad Porooshani on 7/21/16.
//  Copyright © 2016 Porooshani. All rights reserved.
//

import UIKit

private let toSecondViewSegueID = "toSecondViewSegue"

class FirstViewController: UIViewController {
  
  @IBOutlet weak var qrButton: UIButton!
  @IBOutlet weak var qrLabel: UILabel!
  
  var easyPresentAnimationComtroller = EasyPresentAnimationController()
  var easyDismissAnimationComtroller = EasyDismissAnimationController()
  
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
      setupEasyTransition(on: segue.destinationViewController, presentOptions: EasyTransPresentOptions(duration: 0.4, sourceView: qrButton, blurStyle: UIBlurEffectStyle.Dark), dismissOptions: EasyTransDismissOptions(duration: 0.4, destinationView: qrButton))
    default:
      print("Unknown segue!")
    }
    
  }
  
}
