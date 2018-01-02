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
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var des: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func postDidTabbed(_ sender: AnyObject) {
        if let uid = Auth.auth().currentUser?.uid {
            if let header = header.text {
                if let type = type.text {
                    if let quantity = quantity.text {
                        if let des = des.text {
                            let activityObject = [
                                "uid" : uid,
                                "header" : header,
                                "type" : type,
                                "quantity" : quantity,
                                "description" : des,
                            ]
                            
                            Database.database().reference().child("activities").childByAutoId().setValue(activityObject);
                            
                            let alert = UIAlertController(title: "Success", message: "Your post has been sent!", preferredStyle: .alert)
                            let postAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default) { (action) in
                                self.navigationController?.popViewController(animated: true)
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
    
    
}
