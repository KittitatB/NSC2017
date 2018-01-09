//
//  MessageViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/9/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var user: String!
    var messages = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        print ("user " + user)
        navigationItem.title = "Direct Message"
        messageTextfield.placeholder = "Enter Message.."
        observerMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func sendButtonTaped(_ sender: AnyObject) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user
        let fromId = Auth.auth().currentUser?.uid
        let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let message: [String: Any] = ["text": messageTextfield.text!, "toId": toId!, "fromId": fromId!, "timestamp": timestamp]
        childRef.updateChildValues(message)
        messageTextfield.text = ""
        observerMessages()
    }
    
    func observerMessages(){
        messages.removeAllObjects()
        Database.database().reference().child("messages").observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let messagesDictionary = DataSnapshot.value as? [String: AnyObject]{
                for message in messagesDictionary{
                    self.messages.add(message.value)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "messageCellId")
        let message = self.messages[indexPath.row] as! [String: AnyObject]
        if let toId = message["toId"] as? String{
             Database.database().reference().child("photographer").queryOrdered(byChild: "uid").queryEqual(toValue: toId).observe(.childAdded, with: { (DataSnapshot) in
                if let dictionary = DataSnapshot.value as? [String: AnyObject]{
                    cell.textLabel?.text = dictionary["username"] as? String
                }
                print(DataSnapshot)
                }, withCancel: nil)
        }
        cell.detailTextLabel?.text = message["text"] as? String
        return cell
    }
}
