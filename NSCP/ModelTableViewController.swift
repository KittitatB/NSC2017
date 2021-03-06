//
//  ModelTableViewController.swift
//  NSCP
//
//  Created by MuMhu on 11/14/2560 BE.
//  Copyright © 2560 MuMhu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ModelTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterUserDelegate {

    var models = NSMutableArray()
    var userid = ""
    @IBOutlet weak var modelTableView: UITableView!
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelTableView.delegate = self
        self.modelTableView.dataSource =  self
        self.modelTableView.separatorStyle = .none
        loadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        Database.database().reference().child("user").queryOrdered(byChild: "type").queryEqual(toValue: "model").observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let modelsDictionary = DataSnapshot.value as? [String: AnyObject]{
                for model in modelsDictionary{
                    self.models.add(model.value)
                }
                self.modelTableView.reloadData()
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "modelCell", for: indexPath) as! ModelTableViewCell
        // Configure the cell...
        let model = self.models[indexPath.row] as! [String: AnyObject]
        cell.modelName.text = model["username"] as? String
        if let imageName = model["image"] as? String{
            cell.modelImage.loadImageUsingCacheUsingImageName(imageName: imageName)
        }
        let uid = model["uid"] as? String
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
        cell.modelImage.alpha = 0
        cell.modelImage.alpha = 0
        cell.randomPic1.alpha = 0
        cell.randomPic2.alpha = 0
        cell.randomPic3.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            cell.modelImage.alpha = 1
            cell.modelImage.alpha = 1
            cell.randomPic1.alpha = 1
            cell.randomPic2.alpha = 1
            cell.randomPic3.alpha = 1
        })
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ModelUser"){
            let NextViewController = segue.destination as! UserModelViewController
            NextViewController.type = "model"
            NextViewController.user = self.userid
        }
        
        if(segue.identifier == "FilterSegue"){
            let NextViewController = segue.destination as! ShooterFilterController
            NextViewController.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.item] as! [String: AnyObject]
        userid = (model["uid"] as? String)!
        self.performSegue(withIdentifier: "ModelUser", sender: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let index = self.modelTableView.indexPathForSelectedRow{
            self.modelTableView.deselectRow(at: index, animated: true)
        }
    }
    
    func filterByName(name: String?) {
        models.removeAllObjects()
        Database.database().reference().child("user").queryOrdered(byChild: "type").queryEqual(toValue: "model").observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let modelsDictionary = DataSnapshot.value as? [String: AnyObject]{
                for model in modelsDictionary{
                    let dict = model.value as! [String: AnyObject]
                    if(dict["username"] as? String == name!){
                        self.models.add(model.value)
                    }
                }
                self.modelTableView.reloadData()
            }
        })
    }
    
    
    
    @IBAction func filterDidPress(_ sender: AnyObject) {
        performSegue(withIdentifier: "FilterSegue", sender: self)
        
    }
    
    func resetData() {
        models.removeAllObjects()
        loadData()
    }
    
    func filterByInterest(interest: String?) {
        models.removeAllObjects()
        Database.database().reference().child("user").queryOrdered(byChild: "type").queryEqual(toValue: "model").observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let modelsDictionary = DataSnapshot.value as? [String: AnyObject]{
                for model in modelsDictionary{
                    let dict = model.value as! [String: AnyObject]
                    if(dict["location"] as? String == interest!){
                        self.models.add(model.value)
                    }
                }
                self.modelTableView.reloadData()
            }
        })
    }

    
}
    
    

