//
//  UserViewController.swift
//  NSCP
//
//  Created by MuMhu on 10/29/2560 BE.
//  Copyright © 2560 MuMhu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UserViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userFacebookLink: UILabel!
    @IBOutlet weak var userInterest: UILabel!
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadData(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("photographer").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observe(.childAdded, with: { (DataSnapshot) in
            let dict = DataSnapshot.value as! [String: AnyObject]
            self.userName.text = dict["username"] as? String
            self.userFacebookLink.text = dict["link"] as? String
            self.userInterest.text = dict["location"] as? String
            if let imageName = dict["image"] as? String{
                let imageRef = Storage.storage().reference().child("userPic/\(imageName)")
                imageRef.getData(maxSize: 25*1024*1024, completion: {(data, error) -> Void in
                    if error == nil{
                        let image = UIImage(data: data!)
                        self.userImage.image = image
                    }else {
                        print("Error downloading image: \(error?.localizedDescription)")
                    }
                    
                })
            }
            self.userImage.alpha = 0
            self.userImage.alpha = 0
            
            UIView.animate(withDuration: 0.4, animations: {
            self.userImage.alpha = 1
               self.userImage.alpha = 1
            })
        })
    }



    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
