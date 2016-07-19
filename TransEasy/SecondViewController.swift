//
//  SecondViewController.swift
//  TransEasy
//
//  Created by Mohammad on 7/19/16.
//  Copyright © 2016 Porooshani. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var qiImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closeButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)        
    }
    
    
}
