//
//  ViewController.swift
//  NSCP
//
//  Created by MuMhu on 8/24/2560 BE.
//  Copyright © 2560 MuMhu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var Don: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = NSAttributedString(string: "Don't Have An Account?", attributes: [NSForegroundColorAttributeName:UIColor.white, NSUnderlineStyleAttributeName:1])
        Don.setAttributedTitle(attributedString, for: .normal)
        
    }

    override var shouldAutorotate: Bool {
            return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if Auth.auth().currentUser != nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController")
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func signinTapped(_ sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        Auth.auth().signIn(withEmail: username!, password: password!) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Wrong Username or Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController")
                self.present(vc!, animated: true, completion: nil)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
}

