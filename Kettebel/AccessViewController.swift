//
//  AccessViewController.swift
//  Kettebel
//
//  Created by Duy Bao Nguyen on 9/7/15.
//  Copyright (c) 2015 Duy Bao Nguyen. All rights reserved.
//

import UIKit
import Alamofire

class AccessViewController: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    var mainTitleValue : String?
    var subtitleValue : String?
    var syncCodeValue : String?
    
    @IBOutlet weak var n0: UITextField!
    @IBOutlet weak var n1: UITextField!
    @IBOutlet weak var n2: UITextField!
    @IBOutlet weak var n3: UITextField!
    @IBOutlet weak var n4: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if syncCodeValue == nil {
            n0.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if mainTitleValue != nil {
            mainTitle.text = mainTitleValue
        }
        if subtitleValue != nil {
            subtitle.text = subtitleValue
        }
        if syncCodeValue != nil {
            let charArr = syncCodeValue?.componentsSeparatedByString("")
            
            n0.text = String(syncCodeValue![advance(syncCodeValue!.startIndex, 0)])
            n1.text = String(syncCodeValue![advance(syncCodeValue!.startIndex, 1)])
            n2.text = String(syncCodeValue![advance(syncCodeValue!.startIndex, 2)])
            n3.text = String(syncCodeValue![advance(syncCodeValue!.startIndex, 3)])
            n4.text = String(syncCodeValue![advance(syncCodeValue!.startIndex, 4)])
            
            n0.enabled = false
            n1.enabled = false
            n2.enabled = false
            n3.enabled = false
            n4.enabled = false
        }
    }
    
    func sendAccessRequest() {
        let syncCode = n0.text + n1.text + n2.text + n3.text + n4.text
        println(syncCode)
        
        Alamofire.request(.GET, "http://kattebel.parseapp.com/note/" + syncCode, headers : Config.Headers.Keys, parameters: nil)
            .responseJSON { request, response, data, error in
                println(request)
                if (error != nil) {
                    println(error)
                }
                else {
                    let json = JSON(data!)
                    println(json["content"])
                    let noteController = self.storyboard!.instantiateViewControllerWithIdentifier("NoteViewController") as! NoteViewController
                    noteController.isNotAdd = true
                    self.navigationController?.pushViewController(noteController, animated: true)
                    
                    let prefs = NSUserDefaults.standardUserDefaults()
                    prefs.setObject(json["uuid"].string, forKey: "currentNoteId")
                    prefs.setObject(json["content"].string, forKey: "currentNoteContent")
                }
        }
    }

    @IBAction func n0Changed(sender: AnyObject) {
        if count(self.n0.text) == 1 {
            self.n1.becomeFirstResponder()
        }
    }
    
    @IBAction func n1Changed(sender: AnyObject) {
        if count(self.n1.text) == 1 {
            self.n2.becomeFirstResponder()
        }
        else if count(self.n1.text) == 0 {
            self.n0.becomeFirstResponder()
        }
    }
    
    @IBAction func n2Changed(sender: AnyObject) {
        if count(self.n2.text) == 1 {
            self.n3.becomeFirstResponder()
        }
        else if count(self.n2.text) == 0 {
            self.n1.becomeFirstResponder()
        }
    }
    
    @IBAction func n3Changed(sender: AnyObject) {
        if count(self.n3.text) == 1 {
            self.n4.becomeFirstResponder()
        }
        else if count(self.n3.text) == 0 {
            self.n2.becomeFirstResponder()
        }
    }
    
    @IBAction func n4Changed(sender: AnyObject) {
        if count(self.n4.text) == 1 {
            self.sendAccessRequest()
        }
        else if count(self.n4.text) == 0 {
            self.n3.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}