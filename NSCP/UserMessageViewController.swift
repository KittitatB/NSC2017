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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        observerMessages()
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func observerMessages(){
        Database.database().reference().child("messages").observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let messagesDictionary = DataSnapshot.value as? [String: AnyObject]{
                for mess in messagesDictionary{
                    let message = Message()
                    message.setValuesForKeys(mess.value as! [String : Any])
                    if let toId = message.toId{
                        self.messageDic[toId] = message
                        self.messages = Array(self.messageDic.values)
                        self.messages.sort(by: { (firstMessage, secoundMessage) -> Bool in
                            return (firstMessage.timestamp?.intValue)! > (secoundMessage.timestamp?.intValue)!
                        })
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let message = self.messages[indexPath.row]
        if let toId = message.toId{
            Database.database().reference().child("photographer").queryOrdered(byChild: "uid").queryEqual(toValue: toId).observe(.childAdded, with: { (DataSnapshot) in
                if let dictionary = DataSnapshot.value as? [String: AnyObject]{
                    cell.title?.text = dictionary["username"] as? String
                    if let imageName = dictionary["image"] as? String{
                        let imageRef = Storage.storage().reference().child("userPic/\(imageName)")
                        imageRef.getData(maxSize: 25*1024*1024, completion: {(data, error) -> Void in
                            if error == nil{
                                let image = UIImage(data: data!)
                                cell.userImage.image = image
                            }else {
                                print("Error downloading image: \(error?.localizedDescription)")
                            }
                            
                        })
                    }
                }
                print(DataSnapshot)
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

}
