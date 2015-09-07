//
//  NoteViewController.swift
//  Kettebel
//
//  Created by Duy Bao Nguyen on 9/7/15.
//  Copyright (c) 2015 Duy Bao Nguyen. All rights reserved.
//

import UIKit
import Alamofire

class NoteViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        
        createNote()
        
        var updateTimer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: "updateNote", userInfo: nil, repeats: true)
    }
    
    // MARK: Requests
    
    func createNote() {
        Alamofire.request(.GET, "http://kattebel.parseapp.com/note/new")
            .responseJSON { request, response, data, error in
                println(request)
                println(error != nil)
                println(data)
                if (error != nil) {
                    println(error)
                }
                else {
                    let json = JSON(data!)
                    println(json["uuid"])
                    
                    let prefs = NSUserDefaults.standardUserDefaults()
                    prefs.setObject(json["uuid"].string, forKey: "currentNoteId")
                }
        }
    }

    func updateNote() {
        let prefs = NSUserDefaults.standardUserDefaults()
        let uuid = prefs.stringForKey("currentNoteId")
        
        let apiURLString = "http://kattebel.parseapp.com/note/" + uuid! + "/update"
        let parameters: [String: AnyObject] = [
            "uuid" : uuid!,
            "content" : textView.text
        ]
        
        let request = Alamofire.request(.PUT, apiURLString, parameters: parameters, encoding: .JSON)
        request.responseJSON { request, response, data, error in
            println(request)
            println(response)
            println(data)
            println(error)
        }
    }
    
    // MARK: Actions
    
    @IBAction func done(sender: UIButton) {
        textView.resignFirstResponder()
    }
    
    @IBAction func close(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func sync(sender: UIButton) {
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { request, response, data, error in
                println(request)
                println(response)
                println(error)
        }
    }
}
