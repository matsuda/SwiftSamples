//
//  ViewController.swift
//  TestReactiveCocoa
//
//  Created by Kosuke Matsuda on 2015/08/24.
//  Copyright © 2015年 matsuda. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!

    var signInService = DummySignInService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let searchStrings = textField.rac_textSignal()
//        .toSignalProducer()
//        .map { text in text as! String }

        self.label.hidden = true
//        test1()
//        test2()
        test3()
//        test_90()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
     http://www.raywenderlich.com/62699/reactivecocoa-tutorial-pt1
     */
    func test3() {
        let validTextSignal = textField.rac_textSignal()
            .map { (value: AnyObject!) -> AnyObject! in
                return self.isValidText(value as! String)
            }
        let validPasswordSignal = passwordField.rac_textSignal()
            .map { (value: AnyObject!) -> AnyObject! in
                return self.isValidPassword(value as! String)
            }

        // RAC(xxx, xxx) MACRO?
        RACSubscriptingAssignmentTrampoline(target: textField, nilValue: nil)
            .setObject(validTextSignal
                .map { (value: AnyObject!) -> AnyObject! in
                    return (value as! Bool) ? UIColor.clearColor() : UIColor.yellowColor()
                },
                forKeyedSubscript: "backgroundColor")

        RACSubscriptingAssignmentTrampoline(target: passwordField, nilValue: nil)
            .setObject(validPasswordSignal
                .map { (value: AnyObject!) -> AnyObject! in
                    return (value as! Bool) ? UIColor.clearColor() : UIColor.yellowColor()
                },
                forKeyedSubscript: "backgroundColor")

//        validTextSignal
//            .map { (value: AnyObject!) -> AnyObject! in
//                return (value as! Bool) ? UIColor.clearColor() : UIColor.yellowColor()
//            }
//            .subscribeNext { (value: AnyObject!) -> Void in
//                self.textField.backgroundColor = (value as? UIColor)
//            }
//
//        validPasswordSignal
//            .map { (value: AnyObject!) -> AnyObject! in
//                return (value as! Bool) ? UIColor.clearColor() : UIColor.yellowColor()
//            }
//            .subscribeNext { (value: AnyObject!) -> Void in
//                self.passwordField.backgroundColor = (value as? UIColor)
//            }

        let buttonActiveSignal = RACSignal.combineLatest([validTextSignal, validPasswordSignal]).and()
        buttonActiveSignal.subscribeNext { (value: AnyObject!) -> Void in
            self.button.enabled = (value as! Bool)
        }

        button.rac_signalForControlEvents(.TouchUpInside)
//            .map { (x: AnyObject!) -> AnyObject! in
//                return self.signInSignal()
//            }
            .doNext { (x: AnyObject!) -> Void in
                self.button.enabled = false
                self.label.hidden = true
            }
            .flattenMap { (x: AnyObject!) -> RACStream! in
                return self.signInSignal()
            }
            .subscribeNext { (x) -> Void in
                print("Sing in result : \(x)")
                let result = x as! Bool
                self.button.enabled = true
                self.label.hidden = result
            }
    }

    func isValidText(text: String) -> Bool {
        return text.characters.count > 3
    }

    func isValidPassword(text: String) -> Bool {
        return text.characters.count >= 8
    }

    func signInSignal() -> RACSignal {
        return RACSignal.createSignal { (subscriber: RACSubscriber!) -> RACDisposable! in
            self.signInService.signIn(username: self.textField.text, password: self.passwordField.text, complete: { (success: Bool) -> () in
                subscriber.sendNext(success)
                subscriber.sendCompleted()
            })
            return nil
        }
    }

    func test2() {
        textField.rac_textSignal()
            .map { (value: AnyObject!) -> AnyObject! in
                return (value as? String)?.characters.count
            }
            .filter { (value: AnyObject!) -> Bool in
                return (value as? Int) > 3
            }
            .subscribeNext { (value:AnyObject!) -> Void in
                print(value)
            }
    }

    func test1() {
        let textFieldSignal = textField.rac_textSignal()
        let filterSignal = textFieldSignal.filter { (x) -> Bool in
            return (x as! String).characters.count > 3
        }
        filterSignal.subscribeNext { (x) -> Void in
            print(x)
        }
    }

    /*
    http://qiita.com/bonegollira/items/12b451046bc14ecf5d97
    */
    func test_90() {
        textField.rac_textSignal()
            .map { (value: AnyObject!) -> AnyObject! in
                return (value as? String)?.uppercaseString
            }
            .subscribeNext { (value: AnyObject!) -> Void in
                print(value)
            }
        button.rac_command = RACCommand(signalBlock: { (_:AnyObject!) -> RACSignal! in
            self.textField.text = ""
            return RACSignal.empty()
        })
    }
}

