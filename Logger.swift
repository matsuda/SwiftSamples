//
//  Logger.swift
//  MuddlerKit
//
//  Created by Kosuke Matsuda on 2016/01/08.
//  Copyright © 2016年 Kosuke Matsuda. All rights reserved.
//

import Foundation

public class Logger {
    static let defaultLogger = Logger()

    var path: String

    public init() {
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let dirURL = NSURL(fileURLWithPath: dir, isDirectory: true)
        let appName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as! String
        path = dirURL.URLByAppendingPathComponent("\(appName).log").path!
        prepare()
    }

    public func prepare() {
        let fm = NSFileManager.defaultManager()
        if !fm.fileExistsAtPath(path) {
            fm.createFileAtPath(path, contents: nil, attributes: nil)
        }
    }

    public func clean() {
        let fm = NSFileManager.defaultManager()
        if fm.fileExistsAtPath(path) {
            do {
                try fm.removeItemAtPath(path)
            } catch {}
        }
    }

    public func log(body: Any? = nil, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
        log(body == nil ? "" : body, function: function, file: file, line: line)
    }

    public func log(@autoclosure body: () -> Any, function: String = __FUNCTION__, file: String = __FILE__, line: Int = __LINE__) {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.systemTimeZone()
        formatter.locale = NSLocale.currentLocale()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let date = formatter.stringFromDate(NSDate())
        var text = "\(date) [\((file as NSString).lastPathComponent):\(line)] <\(function)> \(body())"
        print(text)
        text += "\r\n"
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            if let handle = NSFileHandle(forWritingAtPath: path) {
                handle.seekToEndOfFile()
                handle.writeData(data)
                handle.closeFile()
            }
        }
        /*
        do {
            try text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            print("error >>> \(error)")
        }
        */
    }

    public class func log(body: Any? = nil) {
        log(body == nil ? "" : body)
    }

    public class func log(@autoclosure body: () -> Any) {
        self.defaultLogger.log(body)
    }
}
