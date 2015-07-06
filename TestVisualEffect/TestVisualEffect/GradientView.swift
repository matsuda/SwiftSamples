//
//  GradientView.swift
//  TestVisualEffect
//
//  Created by Kosuke Matsuda on 2015/07/06.
//  Copyright © 2015年 matsuda. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable var startColor: UIColor = UIColor(red: 120/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1) {
        didSet {
            updateView()
        }
    }

    @IBInspectable var endColor: UIColor = UIColor(red: 100/255.0, green: 80/255.0, blue: 120/255.0, alpha: 1) {
        didSet {
            updateView()
        }
    }

    @IBInspectable var horizontal: Bool = false {
        didSet {
            updateView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }

    func initialize() {
        updateView()
    }

    func updateView() {
        let gradient: CAGradientLayer = self.layer as! CAGradientLayer
        gradient.colors = [
            startColor.CGColor,
            endColor.CGColor,
        ]
        if horizontal {
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        }
    }
}
