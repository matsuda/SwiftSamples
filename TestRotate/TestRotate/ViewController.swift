//
//  ViewController.swift
//  TestRotate
//
//  Created by Kosuke Matsuda on 2015/05/28.
//  Copyright (c) 2015年 matsuda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.forceRotateDeviceToOrientation(.LandscapeLeft, fromOrientation: .Portrait)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.forceRotateDeviceToOrientation(.Portrait, fromOrientation: .LandscapeLeft)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func shouldAutorotate() -> Bool {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if orientation != .LandscapeRight {
            return true
        }
        return false
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.LandscapeRight.rawValue)
    }

    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .LandscapeRight;
    }

    func forceRotateDeviceToOrientation(toRotation: UIDeviceOrientation, fromOrientation: UIDeviceOrientation) {
        let orientationKey = "orientation"

        let actualDeviceOrientation = UIDevice.currentDevice().orientation
        var changedDeviceOrientation = false
        if actualDeviceOrientation != toRotation {
            UIDevice.currentDevice().setValue(toRotation.rawValue, forKey: orientationKey)
        } else {
            UIDevice.currentDevice().setValue(fromOrientation.rawValue, forKey: orientationKey)
            changedDeviceOrientation = true
        }
        UIViewController.attemptRotationToDeviceOrientation()
        if changedDeviceOrientation {
            UIDevice.currentDevice().setValue(actualDeviceOrientation.rawValue, forKey: orientationKey)
        }
    }
}

