//
//  CommentViewController.swift
//  NSCP
//
//  Created by MuMhu on 2/9/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var commendTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    var comments = [Commend]()
    var user: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comment"
        self.tableview.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func observerComments(){
        comments.removeAll()
        let userMessagesRef = Database.database().reference().child("user-comment").child(user!)
        userMessagesRef.observe(.childAdded
            , with: { (DataSnapshot) in
                let messagesKey = DataSnapshot.key
                let messagesRef = Database.database().reference().child("comments").child(messagesKey)
                messagesRef.observeSingleEvent(of: .value, with: { (SnapShot) in
                    if let dictionary = SnapShot.value as? [String : AnyObject] {
                        let comment = Commend()
                        comment.setValuesForKeys(dictionary)
                        self.comments.append(comment)
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                        }
                    }
                })
                
        }, withCancel: nil)
        
        
    }
    
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16
            )], context: nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 75
        if let text = comments[indexPath.item].text{
            height = estimateFrameForText(text: text).height + 12
            if height < 75{
                height = 75
            }
        }
        
        return CGFloat(height)

    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.item]
        Database.database().reference().child("user").queryOrdered(byChild: "uid").queryEqual(toValue: comment.fromId).observe(.childAdded, with: { (DataSnapshot) in
            let dict = DataSnapshot.value as! [String: AnyObject]
            cell.commentName.text = dict["username"] as? String
            if let imageName = dict["image"] as? String{
                cell.commentImage.loadImageUsingCacheUsingImageName(imageName: imageName)
            }
        })
        cell.commentTextview.text = comment.text
        cell.commentTextview.isEditable = false
        cell.commentTextview.isScrollEnabled = false
        return cell
    }

    @IBAction func commentDidPress(_ sender: Any) {
        guard (commendTextField != nil) else {
            return
        }
        let ref = Database.database().reference().child("comments")
        let childRef = ref.childByAutoId()
        let toId = user
        let fromId = Auth.auth().currentUser?.uid
        let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let message: [String: Any] = ["text": commendTextField.text!, "fromId": fromId!, "timestamp": timestamp]
        childRef.updateChildValues(message)
        let userMessageRef = Database.database().reference().child("user-comment").child(toId!)
        let messageId = childRef.key
        userMessageRef.updateChildValues([messageId: 1])
        commendTextField.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        observerComments()
    }
 
}
