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
    func resetData()
    func filterByInterest(interest: String?)
}

class ShooterFilterController: UIViewController {
    @IBOutlet weak var textfield: UITextField!
    var filterer:UIAlertController!
    var delegate: FilterUserDelegate?
    var filterMode: Int = 0
    
    @IBOutlet weak var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        filterer = UIAlertController(title: "Choose Your Filterer", message: "ต้องการฟิลเตอร์จากอะไร", preferredStyle: UIAlertControllerStyle.actionSheet)
        let namefilter = UIAlertAction(title: "Name", style: UIAlertActionStyle.default) { (action) in
            self.filterButton.setTitle("Name", for: .normal)
            self.filterMode = 1
        }
        let interestFilter = UIAlertAction(title: "Interest", style: UIAlertActionStyle.default) { (action) in
            self.filterButton.setTitle("Interest", for: .normal)
            self.filterMode = 2
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        filterer.addAction(namefilter)
        filterer.addAction(interestFilter)
        filterer.addAction(cancelAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func filter(_ sender: AnyObject) {
        if(filterMode == 0){
            delegate?.resetData()
            _ = navigationController?.popViewController(animated: true)
        }
        if(filterMode == 1){
            delegate?.filterByName(name: textfield.text!)
            _ = navigationController?.popViewController(animated: true)
        }
        if(filterMode == 2){
            delegate?.filterByInterest(interest: textfield.text!)
            _ = navigationController?.popViewController(animated: true)
        }
    }

    
    @IBAction func chooseFilterer(_ sender: Any) {
        self.present(filterer, animated: true, completion: nil)
    }

}
