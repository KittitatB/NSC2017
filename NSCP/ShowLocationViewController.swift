//
//  ShowLocationViewController.swift
//  NSCP
//
//  Created by MuMhu on 2/12/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase

class ShowLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var location: String?
    var posts = [Post]()
    var sendPost: Post?
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.separatorStyle = .none
        locationLabel.text = location
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableview.indexPathForSelectedRow{
            self.tableview.deselectRow(at: index, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func loadData(){
        posts.removeAll()
        Database.database().reference().child("posts").queryOrdered(byChild: "location").queryEqual(toValue: location!).observeSingleEvent(of: .value, with: {
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
                self.tableview.reloadData()
            }
        })

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a reference to our storyboard cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "showLocationCell", for: indexPath as IndexPath) as! ShowLocationTableViewCell
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let post = self.posts[indexPath.row]
        if let imageName = post.image{
            cell.cellImage.loadPostImageUsingCacheUsingImageName(imageName: imageName)
        }
        cell.cellImage.alpha = 0
        cell.cellName.text = post.model
        UIView.animate(withDuration: 0.4, animations: {
            cell.cellImage.alpha = 1
        })
      
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "locationPostSeg"){
            let NextViewController = segue.destination as! ShowPostViewController
            NextViewController.post = self.sendPost!
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sendPost = posts[indexPath.item]
        performSegue(withIdentifier: "locationPostSeg", sender: self)
    }
    
}
