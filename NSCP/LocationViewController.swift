//
//  LocationViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/31/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath as IndexPath) as! LocationTableViewCell
        
        return cell
    }

    

}
