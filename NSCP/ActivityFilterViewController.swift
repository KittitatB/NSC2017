//
//  ActivityFilterViewController.swift
//  NSCP
//
//  Created by MuMhu on 2/12/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
protocol FilterActivityDelegate {
    func resetData()
    func filterByName(name: String?)
    func filterByType(type: String?)
    func filterByLocation(location: String?)
}

class ActivityFilterViewController: UIViewController {
    var delegate: FilterActivityDelegate?
    var filterMode : Int = 0
    var filterer:UIAlertController!
    var typeAction:UIAlertController!
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
        let interestFilter = UIAlertAction(title: "Type", style: UIAlertActionStyle.default) { (action) in
            self.choserFilterButton.setTitle("Type", for: .normal)
            self.filterMode = 2
            self.present(self.typeAction, animated: true, completion: nil)
        }
        let locationFilter = UIAlertAction(title: "location", style: UIAlertActionStyle.default) { (action) in
            self.choserFilterButton.setTitle("location", for: .normal)
            self.filterMode = 3
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        filterer.addAction(namefilter)
        filterer.addAction(interestFilter)
        filterer.addAction(locationFilter)
        filterer.addAction(cancelAction)
        self.hideKeyboardWhenTappedAround()
        typeAction = UIAlertController(title: "Choose Your Filterer", message: "เลือกประเภทที่ต้องการค้นหา", preferredStyle: UIAlertControllerStyle.actionSheet)
        let hiredPG = UIAlertAction(title: "จ้างช่างภาพ", style: UIAlertActionStyle.default) { (action) in
            self.choserFilterButton.setTitle("จ้างช่างภาพ", for: .normal)
        }
        let hiredMo = UIAlertAction(title: "จ้างนางแบบหรือนายแบบ", style: UIAlertActionStyle.default) { (action) in
            self.choserFilterButton.setTitle("จ้างนางแบบหรือนายแบบ", for: .normal)
        }
        let openTrip = UIAlertAction(title: "ทริปถ่ายรูป", style: UIAlertActionStyle.default) { (action) in
            self.choserFilterButton.setTitle("ทริปถ่ายรูป", for: .normal)
        }
        typeAction.addAction(hiredPG)
        typeAction.addAction(hiredMo)
        typeAction.addAction(openTrip)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func chooseFilter(_ sender: Any) {
        self.present(filterer, animated: true, completion: nil)
    }
    
    
    @IBAction func filterDidPressed(_ sender: Any) {
        if(filterMode == 0){
            delegate?.resetData()
            _ = navigationController?.popViewController(animated: true)
        }
        if(filterMode == 1){
            delegate?.filterByName(name: textfield.text!)
            _ = navigationController?.popViewController(animated: true)
        }
        if(filterMode == 2){
            delegate?.filterByType(type: choserFilterButton.titleLabel?.text!)
            _ = navigationController?.popViewController(animated: true)
        }
        if(filterMode == 3){
            delegate?.filterByLocation(location: textfield.text!)
            _ = navigationController?.popViewController(animated: true)
        }
    }
   
    
}
