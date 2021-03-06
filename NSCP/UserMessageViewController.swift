//
//  UserMessageViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/13/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
class UserMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var messages = [Message()]
    var messageDic = [String: Message]()
    var sendId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Direct Message"
        self.tableView.separatorStyle = .none
        observeUserMessage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func observeUserMessage(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
    
            let ref = Database.database().reference().child("user-message").child(uid)
            ref.observe(.childAdded
                , with: { (DataSnapshot) in
                    let messageId = DataSnapshot.key
                    let MessagesRef = Database.database().reference().child("messages").child(messageId)
                    MessagesRef.observeSingleEvent(of: .value, with: { (Data) in
                        if let messagesDictionary = Data.value as? [String: AnyObject]{
                            let message = Message()
                            
                            message.setValuesForKeys(messagesDictionary)
                            if let toId = message.chatPartnerId(){
                                self.messageDic[toId] = message
                                self.messages = Array(self.messageDic.values)
                                self.messages.sort(by: { (firstMessage, secoundMessage) -> Bool in
                                    return (firstMessage.timestamp?.intValue)! > (secoundMessage.timestamp?.intValue)!
                                })
                            }
                    
                            DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                    })
                }, withCancel: nil)
    }
    
    
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        if let chatPartnerId = message.chatPartnerId(){
            self.sendId = chatPartnerId
        }
        else {
            return
        }
        self.performSegue(withIdentifier: "showUserChat", sender: self.sendId)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let message = self.messages[indexPath.row]
        if let toId = message.chatPartnerId(){
            Database.database().reference().child("user").queryOrdered(byChild: "uid").queryEqual(toValue: toId).observe(.childAdded, with: { (DataSnapshot) in
                if let dictionary = DataSnapshot.value as? [String: AnyObject]{
                    cell.title?.text = dictionary["username"] as? String
                    cell.userImage.image = nil
                    if let imageName = dictionary["image"] as? String{
                        cell.userImage.loadImageUsingCacheUsingImageName(imageName: imageName)
                    }
                }
                }, withCancel: nil)
        }
        cell.detail?.textColor = cell.detailTextLabel?.textColor
        cell.detail?.text = message.text
        
        if let seconds = message.timestamp?.doubleValue{
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm:ss a"
            cell.timeLabel.text = dateformatter.string(from: timestampDate as Date)
        }
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        observeUserMessage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "DM"
        navigationItem.backBarButtonItem = backItem
        if (segue.identifier == "showUserChat"){
            let NextViewController = segue.destination as! MessageViewController
            NextViewController.user = self.sendId
        }
    }
    
}
