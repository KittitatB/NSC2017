//
//  MessageViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/9/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
class MessageViewController: UIViewController {

    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Direct Message"
        messageTextfield.placeholder = "Enter Message.."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func sendButtonTaped(_ sender: AnyObject) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let message = ["text": messageTextfield.text!]
        childRef.updateChildValues(message)
        messageTextfield.text = ""
    }

}
