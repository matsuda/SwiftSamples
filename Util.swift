//
//  Util.swift
//  TestGeocoder
//
//  Created by Kosuke Matsuda on 2015/05/05.
//  Copyright (c) 2015年 Kosuke Matsuda. All rights reserved.
//

import Foundation

func APPLog(_ message: String = "", line: Int = __LINE__, function: String = __FUNCTION__) {
    println("\(function)[\(line)] \(message)")
}
