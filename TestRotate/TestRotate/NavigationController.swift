//
//  NavigationController.swift
//  TestRotate
//
//  Created by Kosuke Matsuda on 2015/05/28.
//  Copyright (c) 2015年 matsuda. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func shouldAutorotate() -> Bool {
        if self.topViewController is ViewController {
            return self.topViewController.shouldAutorotate()
        }
        let orientation = UIApplication.sharedApplication().statusBarOrientation;
        if orientation != .Portrait {
            return true
        }
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        if self.topViewController is ViewController {
            return self.topViewController.supportedInterfaceOrientations()
        }
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }

    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        if self.topViewController is ViewController {
            return self.topViewController.preferredInterfaceOrientationForPresentation()
        }
        return .Portrait
    }
}
