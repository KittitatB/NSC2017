//
//  LocationFilterViewController.swift
//  NSCP
//
//  Created by MuMhu on 2/12/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
protocol FilterLocationDelegate {
    func resetData()
    func filterByName(name: String?)

}
class LocationFilterViewController: UIViewController {
    var delegate : FilterLocationDelegate?
    var filterMode : Int = 0
    var filterer:UIAlertController!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var choserFilterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        filterer = UIAlertController(title: "Choose Your Filterer", message: "คุณต้องการค้นหาจากอะไร", preferredStyle: UIAlertControllerStyle.actionSheet)
        let namefilter = UIAlertAction(title: "Name", style: UIAlertActionStyle.default) { (action) in
            self.choserFilterButton.setTitle("Name", for: .normal)
            self.filterMode = 1
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        filterer.addAction(namefilter)
        filterer.addAction(cancelAction)
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    @IBAction func chooseFilter(_ sender: Any) {
        self.present(filterer, animated: true, completion: nil)
    }

    @IBAction func filterPressed(_ sender: Any) {
        if(filterMode == 0){
            delegate?.resetData()
            _ = navigationController?.popViewController(animated: true)
        }
        if(filterMode == 1){
            delegate?.filterByName(name: textfield.text!)
            _ = navigationController?.popViewController(animated: true)
        }
    }

}
