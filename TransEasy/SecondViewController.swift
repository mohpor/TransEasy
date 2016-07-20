//
//  SecondViewController.swift
//  TransEasy
//
//  Created by Mohammad on 7/19/16.
//  Copyright © 2016 Porooshani. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var qrTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closeButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)        
    }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
    
}
