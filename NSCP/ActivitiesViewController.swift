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
    
    var activities = [Activity]()
    var sendActivity = Activity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .none
    }

    func loadData(){
        activities.removeAll()
        Database.database().reference().child("activities").observeSingleEvent(of: .value, with: {
            (DataSnapshot) in
            if let activitiesDictionary = DataSnapshot.value as? [String: AnyObject]{
                for activityDic in activitiesDictionary{
                    let activity = Activity()
                    activity.setValuesForKeys(activityDic.value as! [String : Any])
                    self.activities.append(activity)
                    self.activities.sort(by: { (first, secound) -> Bool in
                        return (first.timestamp?.intValue)! > (secound.timestamp?.intValue)!
                    })
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
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
        let activity = self.activities[indexPath.row]
        cell.header.text = activity.header
        cell.type.text = activity.action
        cell.detail.text = activity.descriptioner
        cell.quantity.text = String(Int(activity.Moquantity!)+Int(activity.PGquantity!))
        Database.database().reference().child("user").queryOrdered(byChild: "uid").queryEqual(toValue: activity.uid).observe(.childAdded, with: { (DataSnapshot) in
            let dict = DataSnapshot.value as! [String: AnyObject]
            if let imageName = dict["image"] as? String{
                cell.OwnerImage?.loadImageUsingCacheUsingImageName(imageName: imageName)
            }
        })
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        activities.removeAll()
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showActivity"){
            let NextViewController = segue.destination as! ShowActivityViewController
            NextViewController.activity = sendActivity
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendActivity = activities[indexPath.item]
        self.performSegue(withIdentifier: "showActivity", sender: self)
    }
    
}
