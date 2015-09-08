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
    
    var updateTimer : NSTimer?
    
    var isNotAdd : Bool?
    var isHome : Bool?
    
    let headers = [
        "x-parse-application-id": "",
        "x-parse-javascript-key": ""
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isHome != nil {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "One Thoughts", style: UIBarButtonItemStyle.Plain, target: self, action: "openHome")
        }
        
        if isNotAdd == nil {
            textView.becomeFirstResponder()
            createNote()
        }
        
        textView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let prefs = NSUserDefaults.standardUserDefaults()
        let textViewContent = prefs.stringForKey("currentNoteContent")
        if textViewContent != nil {
            textView.text = textViewContent
            textView.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if updateTimer != nil {
            updateTimer?.invalidate()
        }
        
    }
    
    // MARK: Requests
    
    func createNote() {
        Alamofire.request(.GET, "http://kattebel.parseapp.com/note/new", headers : headers)
            .responseJSON { request, response, data, error in
                println(request)
                println(response)
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
        
        Alamofire.request(.PUT, apiURLString, headers : headers, parameters: parameters, encoding: .JSON)
            .responseJSON { request, response, data, error in
                if (error != nil) {
                    println(error)
                }
                else {
                    let json = JSON(data!)
                    println(json)
                    let prefs = NSUserDefaults.standardUserDefaults()
                    prefs.setObject(json["uuid"].string, forKey: "currentNoteId")
                    prefs.setObject(json["content"].string, forKey: "currentNoteContent")
                }
        }
    }
    
    // MARK: Actions

    @IBAction func sync(sender: UIButton) {
        let prefs = NSUserDefaults.standardUserDefaults()
        let uuid = prefs.stringForKey("currentNoteId")
        
        Alamofire.request(.GET, "http://kattebel.parseapp.com/note/" + uuid! + "/sync", headers : headers, parameters: nil)
            .responseJSON { request, response, data, error in
                if (error != nil) {
                    println(error)
                }
                else {
                    let json = JSON(data!)
                    println(json["syncCode"])
                    let accessController = self.storyboard!.instantiateViewControllerWithIdentifier("AccessViewController") as! AccessViewController
                    accessController.mainTitleValue = "Here is your code"
                    accessController.subtitleValue = "You can use this to share your thoughts"
                    accessController.syncCodeValue = json["syncCode"].string
                    self.navigationController?.pushViewController(accessController, animated: true)
                }
        }
    }
    
    // MARK:
    
    func openHome() {
        let homeVC = self.storyboard!.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}

private typealias TextViewDelegate = NoteViewController
extension TextViewDelegate : UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if updateTimer == nil {
            updateTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "updateNote", userInfo: nil, repeats: true)
        }
        else {
            updateTimer?.fire()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        updateTimer?.invalidate()
    }
}
