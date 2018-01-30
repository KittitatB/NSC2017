//
//  ShowPostViewController.swift
//  NSCP
//
//  Created by MuMhu on 1/30/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit

class ShowPostViewController: UIViewController {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var discription: UITextView!
    var post = Post()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func loadData(){
        model.text = post.model
        location.text = post.location
        link.text = post.link
        discription.text = post.descriptioner
        postImage.loadImageUsingCacheUsingImageName(imageName: post.image!)
    }

}
