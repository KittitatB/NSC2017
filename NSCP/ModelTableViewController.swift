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

class ModelTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var models = NSMutableArray()
    @IBOutlet weak var modelTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelTableView.delegate = self
        self.modelTableView.dataSource =  self
        self.modelTableView.separatorStyle = .none
        loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        Database.database().reference().child("model").observeSingleEvent(of: .value, with: {
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
            let imageRef = Storage.storage().reference().child("userPic/\(imageName)")
            imageRef.getData(maxSize: 25*1024*1024, completion: {(data, error) -> Void in
                if error == nil{
                    let image = UIImage(data: data!)
                    cell.modelImage.image = image
                }else {
                    print("Error downloading image: \(error?.localizedDescription)")
                }
                
            })
        }
        cell.modelImage.alpha = 0
        cell.modelImage.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            cell.modelImage.alpha = 1
            cell.modelImage.alpha = 1
        })
        return cell
    }
    
    
}
