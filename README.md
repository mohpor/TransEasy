
<p align="center">
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift_2.2-compatible-4BC51D.svg?style=flat" alt="Swift 2.2 compatible" /></a>
<a href="https://cocoapods.org"><img src='https://img.shields.io/cocoapods/v/TransEasy.svg' /></a>
<a href="http://mit-license.org"><img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="MIT" /></a>

</p>

# TransEasy
An easy to implement custom transitions.
<div align="center">
<img src="images/demo.gif" alt="demo"/>
</div>
### Overview:

This library will help easily customize your transitions (Modal and Push) so that you can be able to move your views from one to another.

---
### How to setup:

#### Cocoapods (Recommended)

1. In your pod file add:
```
pod 'TransEasy'
```
2. In terminal:
```
$ pod update
```

#### Manual

Clone or download this repo, add files inside `Source` folder to your project.

---

### How to use:

#### Real easy approach:

In this method you will setup the transition inside the `prepareForSegue(_:sender)` using provided `UIViewController` extension.

```Swift_2
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    guard let segueID = segue.identifier else {
      print("Could not verify the segue's identity")
      return
    }    

    switch segueID {
    case toSecondViewSegueID:

      // This method adds easy trans to the SecondViewController using the provided options for present and dismiss.
      setupEasyTransition(on: segue.destinationViewController, presentOptions: TransEasyPresentOptions(duration: 0.4, sourceView: qrButton, blurStyle: UIBlurEffectStyle.Dark), dismissOptions: TransEasyDismissOptions(duration: 0.4, destinationView: qrButton))
    default:
      print("Unknown segue!")
    }

  }


```

#### Not so easy approach:
Alternatively, you can implement the `transitioningDelegate` yourself and just use the animator controller.
 * In your view controller add required properties to hold animators:

```Swift_2

    let presentAnimator: EasyPresentAnimationController = EasyPresentAnimationController()
    let dismissAnimator: EasyDismissAnimationController = EasyDismissAnimationController()    
```

* In `prepareForSegue`, set the `transitioningDelegate`:

```Swift_2

segue.destinationViewController.transitioningDelegate = self


```

 * Extend your view controller to use the **TransEasy** transitions:

 ```Swift_2

 extension ViewController: UIViewControllerTransitioningDelegate {

     func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

         guard let secondVC = presented as? SecondViewController else {
             return nil
         }

         presentAnimator.duration = 0.4
         presentAnimator.originalView = qrButton
         presentAnimator.destinationView = secondVC.imgView
         presentAnimator.blurEffectStyle = .Dark


         return presentAnimator
     }

     func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

         guard let secondVC = dismissed as? SecondViewController else {
             return nil
         }
         dismissAnimator.duration = 0.4
         dismissAnimator.originalView = secondVC.imgView
         dismissAnimator.destinationView = qrButton

         return dismissAnimator
     }

 }

 ```
---

### TODO:

- [x] Setup basic Structure for project.
- [x] Create demo views and make the relations.
- [x] Create Required Classes and Protocols
- [x] Add License file.
- [x] Add Documentations.
- [ ] Add screenshots.
- [ ] Add CI.
- [x] Add Pod support.
