//
//  LocationViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/31/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
class LocationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FilterLocationDelegate {
    @IBOutlet weak var tableview: UITableView!
    var locations = [String()]
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath as IndexPath) as! LocationTableViewCell
        let location = locations[indexPath.item]
        cell.locationName.text = location
        Database.database().reference().child("posts").queryOrdered(byChild: "location").queryEqual(toValue: location).observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            var locationImage = [String]()
            if let postsDictionary = DataSnapshot.value as? [String: AnyObject]{
                for postDic in postsDictionary{
                    let post = Post()
                    post.setValuesForKeys((postDic.value as? [String: Any])!)
                    locationImage.append(post.image!)
                }
                if(locationImage.count > 0){
                    cell.image1.loadPostImageUsingCacheUsingImageName(imageName: locationImage[0])
                }
                if(locationImage.count > 1){
                    cell.image2.loadPostImageUsingCacheUsingImageName(imageName: locationImage[1])
                }
                if(locationImage.count > 2){
                    cell.image3.loadPostImageUsingCacheUsingImageName(imageName: locationImage[2])
                }
                if(locationImage.count > 3){
                    cell.image4.loadPostImageUsingCacheUsingImageName(imageName: locationImage[3])
                }
            }
        })
        return cell
    }
    
    func loadData(){
        let postsRef = Database.database().reference().child("posts")
        postsRef.observeSingleEvent(of: .value, with: { (SnapShot) in
            if let postsDictionary = SnapShot.value as? [String: AnyObject]{
                for postsDic in postsDictionary{
                    let post = Post()
                    post.setValuesForKeys(postsDic.value as! [String : Any])
                    if !self.locations.contains(post.location!){
                        self.locations.append(post.location!)
                    }
                }
                if self.locations.contains(""){
                    self.locations.removeFirst()
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        })
    }
    
    
    @IBAction func filterDidPress(_ sender: AnyObject) {
        performSegue(withIdentifier: "locationFilterSeg", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "ModelUser"){
//            let NextViewController = segue.destination as! UserModelViewController
//            NextViewController.type = "model"
//            NextViewController.user = self.userid
//        }
        
        if(segue.identifier == "locationFilterSeg"){
            let NextViewController = segue.destination as! LocationFilterViewController
            NextViewController.delegate = self
        }
    }
    
    func filterByName(name: String?) {
        locations.removeAll()
        self.tableview.reloadData()
        let postsRef = Database.database().reference().child("posts").queryOrdered(byChild: "location").queryEqual(toValue: name!)
        postsRef.observeSingleEvent(of: .value, with: { (SnapShot) in
            if let postsDictionary = SnapShot.value as? [String: AnyObject]{
                for postsDic in postsDictionary{
                    let post = Post()
                    post.setValuesForKeys(postsDic.value as! [String : Any])
                    if !self.locations.contains(post.location!){
                        self.locations.append(post.location!)
                    }
                }
                if self.locations.contains(""){
                    self.locations.removeFirst()
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        })
    }
    
    func resetData() {
        locations.removeAll()
        loadData()
    }
    

}
