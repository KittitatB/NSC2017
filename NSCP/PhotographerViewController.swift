//
//  PhotographerViewController.swift
//  NSCP
//
//  Created by MuMhu on 10/27/2560 BE.
//  Copyright © 2560 MuMhu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PhotographerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterUserDelegate {

    var photographers = NSMutableArray()
    @IBOutlet weak var photographerTableView: UITableView!
    var userid = ""
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photographerTableView.delegate = self
        self.photographerTableView.dataSource =  self
        self.photographerTableView.separatorStyle = .none
        loadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData(){
        Database.database().reference().child("user").queryOrdered(byChild: "type").queryEqual(toValue: "photographer").observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let photographersDictionary = DataSnapshot.value as? [String: AnyObject]{
                for photographer in photographersDictionary{
                    self.photographers.add(photographer.value)
                }
                self.photographerTableView.reloadData()
            }
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.photographers.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photographerCell", for: indexPath) as!PhotographerTableViewCell
        // Configure the cell...
        let photographer = self.photographers[indexPath.row] as! [String: AnyObject]
        cell.photographerName.text = photographer["username"] as? String
        if let imageName = photographer["image"] as? String{
            cell.photographerImage.loadImageUsingCacheUsingImageName(imageName: imageName)
        }
        let uid = photographer["uid"] as? String
        Database.database().reference().child("posts").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let postsDictionary = DataSnapshot.value as? [String: AnyObject]{
                for postIns in postsDictionary{
                    let post = Post()
                    post.setValuesForKeys(postIns.value as! [String : Any])
                    self.posts.append(post)
                }
            }
        if(self.posts.count > 0){
            print(self.posts[0])
            cell.randomPic1.loadPostImageUsingCacheUsingImageName(imageName: self.posts[0].image!)
        }
        if(self.posts.count > 1){
            print(self.posts[0])
            cell.randomPic2.loadPostImageUsingCacheUsingImageName(imageName: self.posts[1].image!)
        }
        if(self.posts.count > 2){
            print(self.posts[0])
            cell.randomPic3.loadPostImageUsingCacheUsingImageName(imageName: self.posts[2].image!)
        }
        })
        cell.photographerImage.alpha = 0
            cell.photographerImage.alpha = 0
            cell.randomPic1.alpha = 0
            cell.randomPic2.alpha = 0
            cell.randomPic3.alpha = 0
            
            UIView.animate(withDuration: 0.4, animations: {
                cell.photographerImage.alpha = 1
                cell.photographerImage.alpha = 1
                cell.randomPic1.alpha = 1
                cell.randomPic2.alpha = 1
                cell.randomPic3.alpha = 1
            })
            return cell
}
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShooterUser"){
            let NextViewController = segue.destination as! UserModelViewController
            NextViewController.type = "photographer"
            NextViewController.user = self.userid
        }
        
        if(segue.identifier == "FilterSeg"){
            let NextViewController = segue.destination as! ShooterFilterController
            NextViewController.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photographer = photographers[indexPath.item] as! [String: AnyObject]
        userid = (photographer["uid"] as? String)!
        self.performSegue(withIdentifier: "ShooterUser", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.photographerTableView.indexPathForSelectedRow{
            self.photographerTableView.deselectRow(at: index, animated: true)
        }
    }
  
    
    
    func filterByName(name: String?) {
        photographers.removeAllObjects()
        Database.database().reference().child("user").queryOrdered(byChild: "type").queryEqual(toValue: "photographer").observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let modelsDictionary = DataSnapshot.value as? [String: AnyObject]{
                for model in modelsDictionary{
                    let dict = model.value as! [String: AnyObject]
                    if(dict["username"] as? String == name!){
                        self.photographers.add(model.value)
                    }
                }
                self.photographerTableView.reloadData()
            }
        })
    }
    
}
