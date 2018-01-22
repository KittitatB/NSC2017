//
//  MessageViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/9/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
class MessageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var messageTextfield: UITextField!

    @IBOutlet weak var collectionview: UICollectionView!
    var user: String?
    var messages = [Message]()
    var bubbleWidthAnchor : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionview.alwaysBounceVertical = true
        navigationItem.backBarButtonItem?.title = "DM"
        messageTextfield.placeholder = "Enter Message.."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadUser(){
        
        Database.database().reference().child("user").queryOrdered(byChild: "uid").queryEqual(toValue: user).observe(.childAdded, with: { (DataSnapshot) in
            let dict = DataSnapshot.value as! [String: AnyObject]
            self.user = dict["uid"] as? String
            self.navigationItem.title = dict["username"] as? String
        })
        messages.removeAll()
    }
    
    @IBAction func sendButtonTaped(_ sender: AnyObject) {
        guard (messageTextfield != nil) else {
            return
        }
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
    }
    
    func observerMessages(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-message").child(uid)
        userMessagesRef.observe(.childAdded
            , with: { (DataSnapshot) in
                let messagesKey = DataSnapshot.key
                let messagesRef = Database.database().reference().child("messages").child(messagesKey)
                messagesRef.observeSingleEvent(of: .value, with: { (SnapShot) in
                    if let dictionary = SnapShot.value as? [String : AnyObject] {
                        let message = Message()
                        message.setValuesForKeys(dictionary)
                        if message.chatPartnerId() == self.user{
                            self.messages.append(message)
                            DispatchQueue.main.async {
                                self.collectionview.reloadData()
                            }
                        }
                    }
                })
                
            }, withCancel: nil)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.item].text{
            height = estimateFrameForText(text: text).height + 15
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16
            )], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath as IndexPath) as! MessageCollectionCell
        let message = messages[indexPath.item]
        cell.bubbleview.translatesAutoresizingMaskIntoConstraints = false
        cell.textview.translatesAutoresizingMaskIntoConstraints = false
        cell.bubbleWidth.constant = estimateFrameForText(text: message.text!).width + 24
        cell.bubbleview.layer.cornerRadius = 16
        cell.bubbleview.layer.masksToBounds = true
        cell.textview.text = message.text
        return cell
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        loadUser()
        observerMessages()
    }
}
