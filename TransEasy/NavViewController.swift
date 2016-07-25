//
//  NavViewController.swift
//  TransEasy
//
//  Created by Mohammad on 7/25/16.
//  Copyright © 2016 Porooshani. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    print("unwindng in navcontroller")
  }
  
  override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
    return true
  }
  
  override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
    
    return nil // Returnin nil for now to fix unwind
    
    print("unwindng override in navcontroller")
    
    let segue = TransEasySegue(identifier: "unwindTrans", source: fromViewController, destination: toViewController)
    segue.sourceView = (fromViewController as? SecondViewController)?.qrImage
    
    return segue
  }
  
}
