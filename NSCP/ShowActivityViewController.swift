//
//  ShowActivityViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/30/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
class ShowActivityViewController: UIViewController {

    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var openerName: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var joined: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var discript: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var timeType: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var modelJoined: UILabel!
    @IBOutlet weak var modelQuantity: UILabel!
    var activity = Activity()
    var key : String?
    var joinedPG = [String]()
    var joinedMO = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUser(){
        let uid = Auth.auth().currentUser?.uid
        let activityPGRef = Database.database().reference().child("activity-user").child("photographer").child(activity.key!)
        activityPGRef.observe(.childAdded
            , with: { (DataSnapshot) in
                let userKey = DataSnapshot.key
                self.joinedPG.append(userKey)
                self.joined.text = String(self.joinedPG.count)
                if(Int(self.activity.PGquantity!) == self.joinedPG.count){
                    self.joinButton.setTitle("Full", for: .normal)
                    self.joinButton.backgroundColor = UIColor.red
                    self.joinButton.setTitleColor(UIColor.black, for: .normal)
                    self.joinButton.isEnabled = false
                }
                if(userKey == uid){
                    self.joinButton.setTitle("Joined", for: .normal)
                    self.joinButton.backgroundColor = UIColor.gray
                    self.joinButton.setTitleColor(UIColor.darkGray, for: .normal)
                    self.joinButton.isEnabled = false
                }
                
        }, withCancel: nil)
        
        let activityMORef = Database.database().reference().child("activity-user").child("model").child(activity.key!)
        activityMORef.observe(.childAdded
            , with: { (DataSnapshot) in
                let userKey = DataSnapshot.key
                if(Int(self.activity.Moquantity!) == self.joinedMO.count){
                    self.joinButton.setTitle("Full", for: .normal)
                    self.joinButton.backgroundColor = UIColor.red
                    self.joinButton.setTitleColor(UIColor.black, for: .normal)
                    self.joinButton.isEnabled = false
                }
                if(userKey == uid){
                    self.joinedMO.append(userKey)
                    self.joined.text = String(self.joinedMO.count)
                    self.joinButton.setTitle("Joined", for: .normal)
                    self.joinButton.backgroundColor = UIColor.gray
                    self.joinButton.setTitleColor(UIColor.darkGray, for: .normal)
                    self.joinButton.isEnabled = false
                }
        }, withCancel: nil)
    }
    
    func loadData(){
        header.text = activity.header
        type.text = activity.action
        joined.text = activity.joined?.stringValue
        quantity.text = String(Int(activity.PGquantity!))
        modelQuantity.text = String(Int(activity.Moquantity!))
        date.text = activity.date
        timeType.text = activity.type
        location.text = activity.location
        discript.text = activity.descriptioner
        Database.database().reference().child("user").queryOrdered(byChild: "uid").queryEqual(toValue: activity.uid).observe(.childAdded, with: { (DataSnapshot) in
            let dict = DataSnapshot.value as! [String: AnyObject]
            if let imageName = dict["image"] as? String{
                self.pic.loadImageUsingCacheUsingImageName(imageName: imageName)
                self.openerName.text = dict["username"] as? String
            }
        })
    }
    
    
    @IBAction func joinDidPressed(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        var userType: String?
        Database.database().reference().child("user").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observe(.childAdded, with: { (DataSnapshot) in
            let dict = DataSnapshot.value as! [String: AnyObject]
            userType = dict["type"] as? String
            print(userType!)
            let activityRef = Database.database().reference().child("activity-user").child(userType!).child(self.activity.key!)
            activityRef.updateChildValues([uid!: 1])
            let alert = UIAlertController(title: "Success", message: "Your joined ths activity!", preferredStyle: .alert)
            let postAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default) { (action) in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(postAction)
            self.present(alert, animated: true, completion: nil)
        })
    }

}
