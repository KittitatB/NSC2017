//
//  ActivityPostViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/2/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ActivityPostViewController: UIViewController {

    @IBOutlet weak var header: UITextField!
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var des: UITextField!
    var typeAction:UIAlertController!
    override func viewDidLoad() {
        super.viewDidLoad()
        typeAction = UIAlertController(title: "Choose Post Type", message: "คุณต้องการตั้งกิจกรรมแบบใด", preferredStyle: UIAlertControllerStyle.actionSheet)
        let photographerHire = UIAlertAction(title: "จ้างช่างภาพ", style: UIAlertActionStyle.default) { (action) in
            self.type.titleLabel?.text = "จ้างช่างภาพ"
        }
        let modelHire = UIAlertAction(title: "จ้างนางแบบ", style: UIAlertActionStyle.default) { (action) in
            self.type.titleLabel?.text = "จ้างนางแบบ"
        }
        let tripActivity = UIAlertAction(title: "เปิดทริป", style: UIAlertActionStyle.default) { (action) in
            self.type.titleLabel?.text = "เปิดทริป"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        typeAction.addAction(photographerHire)
        typeAction.addAction(modelHire)
        typeAction.addAction(tripActivity)
        typeAction.addAction(cancelAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func postDidTabbed(_ sender: AnyObject) {
        let timestamp = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        if let uid = Auth.auth().currentUser?.uid {
            if let header = header.text {
                if let type = type.titleLabel?.text {
                    if let quantity = quantity.text {
                        if let des = des.text {
                            let number = NSNumber(value: Int(quantity)!)
                            let activityObject = [
                                "uid" : uid,
                                "header" : header,
                                "type" : type,
                                "quantity" : number,
                                "joined" : 0,
                                "descriptioner" : des,
                                "timestamp" : timestamp
                            ] as [String : Any]
                            Database.database().reference().child("activities").childByAutoId().setValue(activityObject);
                            
                            let alert = UIAlertController(title: "Success", message: "Your post has been sent!", preferredStyle: .alert)
                            let postAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default) { (action) in
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                            alert.addAction(postAction)
                            self.present(alert, animated: true, completion: nil)
                            print("Post to Firebase.")
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func postTapped(_ sender: AnyObject) {
        print("KUY")
        self.present(typeAction, animated: true, completion: nil)
    }
    
    
    
}
