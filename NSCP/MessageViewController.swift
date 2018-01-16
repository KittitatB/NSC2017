//
//  MessageViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/9/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
class MessageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var messageTextfield: UITextField!

    @IBOutlet weak var collectionview: UICollectionView!
    var user: String!
    var messages = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.title = "DM"
        loadUser()
        messageTextfield.placeholder = "Enter Message.."
        observerMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadUser(){
        
        Database.database().reference().child("photographer").queryOrdered(byChild: "uid").queryEqual(toValue: user).observe(.childAdded, with: { (DataSnapshot) in
            let dict = DataSnapshot.value as! [String: AnyObject]
            self.navigationItem.title = dict["username"] as? String
        })
    }
    
    @IBAction func sendButtonTaped(_ sender: AnyObject) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user
        let fromId = Auth.auth().currentUser?.uid
        let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let message: [String: Any] = ["text": messageTextfield.text!, "toId": toId!, "fromId": fromId!, "timestamp": timestamp]
        childRef.updateChildValues(message)
        let userMessageRef = Database.database().reference().child("user-message").child(fromId!)
        let messageId = childRef.key
        userMessageRef.updateChildValues([messageId: 1])
        let ReciverMessageRef = Database.database().reference().child("user-message").child(toId!)
        ReciverMessageRef.updateChildValues([messageId: 1])
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
            self.collectionview.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath as IndexPath) as! MessageCollectionCell
        return cell
    }
    
   
}
