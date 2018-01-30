//
//  LocationViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/31/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
class LocationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
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
        cell.locationName.text = locations[indexPath.item]
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
            print(self.locations)
        })
    }
    
    

}
