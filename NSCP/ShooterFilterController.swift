//
//  ShooterFilterController.swift
//  NSCP
//
//  Created by MuMhu on 1/24/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit

protocol FilterUserDelegate {
    func filterByName(name: String?)
}

class ShooterFilterController: UIViewController {

    @IBOutlet weak var nameFilter: UITextField!
    @IBOutlet weak var interestFilter: UITextField!
    var delegate: FilterUserDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func filter(_ sender: AnyObject) {
        delegate?.filterByName(name: nameFilter.text!)
        navigationController?.popViewController(animated: true)
    }


}
