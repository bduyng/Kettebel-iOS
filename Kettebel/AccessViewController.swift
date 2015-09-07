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

    @IBOutlet weak var n0: UITextField!
    @IBOutlet weak var n1: UITextField!
    @IBOutlet weak var n2: UITextField!
    @IBOutlet weak var n3: UITextField!
    @IBOutlet weak var n4: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        n0.becomeFirstResponder()
    }
    
    func sendAccessRequest() {
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { request, response, data, error in
                println(request)
                println(response)
                println(error)
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
