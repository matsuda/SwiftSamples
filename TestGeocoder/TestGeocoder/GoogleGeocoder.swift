//
//  GoogleGeocoder.swift
//  TestGeocoder
//
//  Created by Kosuke Matsuda on 2015/05/07.
//  Copyright (c) 2015年 Kosuke Matsuda. All rights reserved.
//

import UIKit

/**
 http://ntaku.hateblo.jp/entry/20120903/1346658917
 */
class GoogleGeocoder: NSObject, UIWebViewDelegate {
    typealias GeocoderHandler = (NSDictionary, NSError?) -> Void

    var webView: UIWebView
    var handler: GeocoderHandler?

    deinit {
        self.webView.delegate = nil
    }

    override init() {
        self.webView = UIWebView()
        super.init()
        webView.delegate = self
        if let path = NSBundle.mainBundle().pathForResource("geocoder", ofType: "html") {
            if let url = NSURL(fileURLWithPath: path) {
                let request = NSURLRequest(URL: url)
                self.webView.loadRequest(request)
            }
        }
    }

    func locationByWord(word: String, completion handler: GeocoderHandler) {
        self.handler = handler
        var text = word
        text = text.stringByReplacingOccurrencesOfString("\"", withString: "", options: nil, range: nil)
        text = text.stringByReplacingOccurrencesOfString("'", withString: "", options: nil, range: nil)
        let js = "search('\(text)')"
        self.webView.stringByEvaluatingJavaScriptFromString(js)
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let str = request.URL?.absoluteString {
            if let r = str.rangeOfString("error://") {
                APPLog("error")
                return false
            } else if let r = str.rangeOfString("geocoder://") {
                let encodedString = str.stringByReplacingOccurrencesOfString("geocoder://", withString: "", options: nil, range: nil)
                let decodedString = decodeString(encodedString)
                var error: NSError?
                if let json = NSJSONSerialization.JSONObjectWithData(decodedString.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
                    APPLog("JJJJ >>> \(json)")
                    if let block = self.handler {
                        block(json, nil)
                    }
                }
                return false
            }
        }
        return true
    }

    func decodeString(text: String) -> String {
        /*
        http://stackoverflow.com/questions/28310589/decode-a-string-in-swift
        */
        return text.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

        /*
        http://qiita.com/yukihamada/items/9c0cc2e2074d5cc0d368
        let encodedString = targetString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let decodedString = encodedString.stringByRemovingPercentEncoding;
        */
//        return text.stringByRemovingPercentEncoding ?? ""

        /*
        https://github.com/TheFlow95/DecodeHTML.swift/blob/master/DecodeHTML.swift
        */
//        return NSAttributedString(data: text.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil, error: nil)!.string

        /*
        http://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift
        */
//        let encodedData = text.dataUsingEncoding(NSUTF8StringEncoding)!
//        let attributedOptions : [String: AnyObject] = [
//            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
//        ]
//        let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)!
//        let decodedString = attributedString.string
//        return decodedString
    }
}
