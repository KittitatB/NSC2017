//
//  SendContactViewController.swift
//  NSCP
//
//  Created by MuMhu on 19/4/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class SendContactViewController: UIViewController {

    @IBOutlet weak var header: UITextField!
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var des: UITextField!
    var typeAction:UIAlertController!
    @IBOutlet weak var date: UITextField!
    var user: String?
    @IBOutlet weak var location: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        navigationItem.title = "จ้างช่างภาพ"
        typeAction = UIAlertController(title: "Choose Post Type", message: "คุณต้องการเลือกการจ้างแบบใด", preferredStyle: UIAlertControllerStyle.actionSheet)
        let halfDay = UIAlertAction(title: "Half Day", style: UIAlertActionStyle.default) { (action) in
            self.type.titleLabel?.text = "Half Day"
        }
        let fullDay = UIAlertAction(title: "Full Day", style: UIAlertActionStyle.default) { (action) in
            self.type.titleLabel?.text = "Full Day"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        typeAction.addAction(halfDay)
        typeAction.addAction(fullDay)
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
                        if let location = location.text {
                            if let des = des.text {
                                if let date = date.text {
                                    let number = quantity
                                    let activityObject = [
                                        "date" : date,
                                        "uid" : uid,
                                        "toid" : user!,
                                        "header" : header,
                                        "type" : type,
                                        "action" : "จ้างช่างภาพ",
                                        "price" : number,
                                        "location" : location,
                                        "joined" : 0,
                                        "descriptioner" : des,
                                        "timestamp" : timestamp
                                        ] as [String : Any]
                                    Database.database().reference().child("contacts").childByAutoId().setValue(activityObject);
                                    
                                    let alert = UIAlertController(title: "Success", message: "Your post has been sent!", preferredStyle: .alert)
                                    let postAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default) { (action) in
                                        //_ = self.navigationController?.popViewController(animated: true)
                                        var viewControllers = self.navigationController?.viewControllers
                                        viewControllers?.removeLast(2) // views to pop
                                        self.navigationController?.setViewControllers(viewControllers!, animated: true)
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
    }
    
    @IBAction func postTapped(_ sender: AnyObject) {
        self.present(typeAction, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem?.title = "Back"
    }
    
}
