//
//  MenuViewController.swift
//  Nimble
//
//  Created by Josh Trommel on 2015-07-17.
//  Copyright (c) 2015 Bright. All rights reserved.
//

import Cocoa

class MenuViewController: NSViewController {

    @IBOutlet weak var progress: NSProgressIndicator!
    @IBOutlet weak var input: NSTextField!
    @IBOutlet weak var assumption: NSTextField!
    @IBOutlet weak var plaintext: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.target = self
        input.action = Selector("query:")
        input.becomeFirstResponder()
        assumption.stringValue = ""
        assumption.selectable = true
        plaintext.selectable = true
        plaintext.stringValue = ""
        // input.cell()?.focusRingType = NSFocusRingType.None // whuaahh
    }
    
    func query(sender: NSTextField?) {
        let query = sender!.stringValue
        let escapedURL = query.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let url = NSURL(string: "https://nimble-backend.herokuapp.com/input?i=\(escapedURL!)")
        
        progress.startAnimation(self)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let json = JSON(data: data)
            if json["result"]["success"] == true {
                
                if let input = json["result"]["input"].string {
                    self.assumption.stringValue = "\"\(input)\""
                }
                
                if let result = json["result"]["result"]["plaintext"].string {
                    self.plaintext.stringValue  = result
                }
                
            } else {
                self.plaintext.stringValue = ""
                self.assumption.stringValue = "Uh oh! I think your query, \"\(self.input.stringValue)\", might be invalid."
            }
            self.progress.stopAnimation(self)
        }
        
        task.resume()
    }
    
}