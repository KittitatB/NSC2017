//
//  ActivitiesViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/2/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ActivitiesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var activities = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
        loadData()
    }

    func loadData(){
        Database.database().reference().child("activities").observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let activitiesDictionary = DataSnapshot.value as? [String: AnyObject]{
                for activity in activitiesDictionary{
                    self.activities.add(activity.value)
                }
                self.tableview.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activitiesCell", for: indexPath) as!ActivitiesTableViewCell
        // Configure the cell...
        let activity = self.activities[indexPath.row] as! [String: AnyObject]
        cell.header.text = activity["header"] as? String
        /*if let imageName = photographer["image"] as? String{
            let imageRef = Storage.storage().reference().child("userPic/\(imageName)")
            imageRef.getData(maxSize: 25*1024*1024, completion: {(data, error) -> Void in
                if error == nil{
                    let image = UIImage(data: data!)
                    cell.photographerImage.image = image
                }else {
                    print("Error downloading image: \(error?.localizedDescription)")
                }
                
            })
        }
        cell.photographerImage.alpha = 0
        cell.photographerImage.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            cell.photographerImage.alpha = 1
            cell.photographerImage.alpha = 1
        })*/
        return cell
    }

    

}
