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

class PhotographerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var photographers = NSMutableArray()
    @IBOutlet weak var photographerTableView: UITableView!
    var userid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photographerTableView.delegate = self
        self.photographerTableView.dataSource =  self
        self.photographerTableView.separatorStyle = .none
        loadData()
//        let FilterVC = storyboard?.instantiateViewController(withIdentifier: "ShooterFilter") as! ShooterFilterController
//        FilterVC.delegate = self

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
        cell.photographerImage.alpha = 0
        cell.photographerImage.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            cell.photographerImage.alpha = 1
            cell.photographerImage.alpha = 1
        })
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShooterUser"){
            let NextViewController = segue.destination as! UserModelViewController
            NextViewController.type = "photographer"
            NextViewController.user = self.userid
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
    
//    func filterByName(name: String?) {
//        photographers.removeAllObjects()
//        Database.database().reference().child("user").queryOrdered(byChild: "type").queryEqual(toValue: "photographer").queryOrdered(byChild: "username").queryEqual(toValue: name).observeSingleEvent(of: .value, with: {
//            (DataSnapshot) in
//            if let photographersDictionary = DataSnapshot.value as? [String: AnyObject]{
//                for photographer in photographersDictionary{
//                    self.photographers.add(photographer.value)
//                }
//                self.photographerTableView.reloadData()
//            }
//        })
//    }
}
