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
    var activity = Activity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        header.text = activity.header
        type.text = activity.type
        joined.text = activity.joined?.stringValue
        quantity.text = activity.quantity?.stringValue
        discript.text = activity.descriptioner
        Database.database().reference().child("user").queryOrdered(byChild: "uid").queryEqual(toValue: activity.uid).observe(.childAdded, with: { (DataSnapshot) in
            let dict = DataSnapshot.value as! [String: AnyObject]
            if let imageName = dict["image"] as? String{
                self.pic.loadImageUsingCacheUsingImageName(imageName: imageName)
                self.openerName.text = dict["username"] as? String
            }
        })
    }

}
