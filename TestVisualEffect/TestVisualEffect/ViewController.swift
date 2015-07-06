//
//  ViewController.swift
//  TestVisualEffect
//
//  Created by Kosuke Matsuda on 2015/07/06.
//  Copyright © 2015年 matsuda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gradientView: GradientView!
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // photo from http://blog.livedoor.jp/freecity/archives/636848.html
        let image = UIImage(named: "sample.jpg")
        let imageView = UIImageView(image: image)
        imageView.frame = self.view.bounds
        self.view.insertSubview(imageView, atIndex: 0)
        self.imageView = imageView
        self.gradientView.hidden = true
        setBlur()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setBlur() {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.imageView.frame
        self.view.addSubview(blurView)
        /*
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": blurView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": blurView]))
        */
        setVibrancy(blurView)
    }

    func setVibrancy(blurView: UIVisualEffectView) {
        let effect = UIVibrancyEffect(forBlurEffect: blurView.effect as! UIBlurEffect)
        let vibrancyView = UIVisualEffectView(effect: effect)
        vibrancyView.frame = self.imageView.frame
        blurView.contentView.addSubview(vibrancyView)

        let label = UILabel(frame: CGRect(x: 0, y: 300, width: self.view.frame.size.width, height: 44))
        label.textAlignment = .Center
        label.text = "vibrancy"
        label.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 40)
        vibrancyView.contentView.addSubview(label)
    }
}

