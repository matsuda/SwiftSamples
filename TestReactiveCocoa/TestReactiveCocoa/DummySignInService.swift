//
//  DummySignInService.swift
//  TestReactiveCocoa
//
//  Created by Kosuke Matsuda on 2015/08/25.
//  Copyright © 2015年 matsuda. All rights reserved.
//

import UIKit

typealias SignInResponse = (Bool -> Void)?

class DummySignInService: NSObject {
    func signIn(username username: String?, password: String?, complete: SignInResponse) {
        let delay = 2.0
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            let success = (username == "user" && password == "password")
            complete?(success)
        })
    }
}
