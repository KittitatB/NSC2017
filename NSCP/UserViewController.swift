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


class UserViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userFacebookLink: UILabel!
    @IBOutlet weak var userInterest: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var imageName = ""
    let reuseIdentifier = "collectionCell"
    var posts = [Post]()
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: width / 3, height: width / 3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        collectionView!.collectionViewLayout = layout
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("posts").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let postsDictionary = DataSnapshot.value as? [String: AnyObject]{
                for postIns in postsDictionary{
                    let post = Post()
                    post.setValuesForKeys(postIns.value as! [String : Any])
                    self.posts.append(post)
                }
                self.posts.sort(by: { (firstPost, secoundPost) -> Bool in
                    return (firstPost.timestamp?.intValue)! > (secoundPost.timestamp?.intValue)!
                })
                self.collectionView.reloadData()
            }
        })
        
        Database.database().reference().child("user").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observe(.childAdded, with: { (DataSnapshot) in
            let dict = DataSnapshot.value as! [String: AnyObject]
            self.userName.text = dict["username"] as? String
            self.userFacebookLink.text = dict["link"] as? String
            self.userInterest.text = dict["location"] as? String
            if let imageName = dict["image"] as? String{
                self.userImage.loadImageUsingCacheUsingImageName(imageName: imageName)
            }
            self.userImage.alpha = 0
            self.userImage.alpha = 0
            
            UIView.animate(withDuration: 0.4, animations: {
            self.userImage.alpha = 1
               self.userImage.alpha = 1
            })
        })
    }


    @IBAction func LoggingOut(_ sender: AnyObject) {
        do{
            print("KUY")
            try Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LandingVC")
            self.present(vc!, animated: true, completion: nil)

        }catch{
            print("Error signing out user.")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! UserCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let post = self.posts[indexPath.row]
        if let imageName = post.image{
            cell.image.loadPostImageUsingCacheUsingImageName(imageName: imageName)
        }
        cell.image.alpha = 0
        cell.image.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            cell.image.alpha = 1
            cell.image.alpha = 1
        })

        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = Int(sectionInsets.left) * (itemsPerRow + 1)
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        posts.removeAll()
        loadData()
    }
    
}
