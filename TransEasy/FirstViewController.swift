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

private let toSecondViewSegueID = "toSecondViewSegue"

class FirstViewController: UIViewController, TransEasyDestinationViewControllerProtocol {
  
  @IBOutlet weak var qrButton: UIButton!
  @IBOutlet weak var qrLabel: UILabel!
  @IBOutlet weak var presentationStyleButton: UIBarButtonItem!
  
  var isSegueModal = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  @IBAction func qrButtonClicked(_ sender: AnyObject) {
    guard let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "secondVC") else {
      return
    }
    // This method adds easy trans to the SecondViewController using the provided options for present and dismiss.
    setupEasyTransition(on: destinationViewController, presentOptions: TransEasyPresentOptions(duration: 0.4, sourceView: qrButton, blurStyle: UIBlurEffect.Style.dark), dismissOptions: TransEasyDismissOptions(duration: 0.4, destinationView: qrButton, interactive: true))
    if isSegueModal {
      present(destinationViewController, animated: true, completion: nil)
    } else {
      performSegue(withIdentifier: toSecondViewSegueID, sender: sender)
    }
    
  }
  
  func transEasyDestinationView() -> UIView {
    return qrButton
  }
  
  @IBAction func modalButtonClicked(_ sender: AnyObject) {
    isSegueModal = !isSegueModal
    presentationStyleButton.title = "Style: " + (isSegueModal ? "Modal" : "Push")
  }
  
}
