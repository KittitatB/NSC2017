//
//  RegisterViewController.swift
//  NSCP
//
//  Created by MuMhu on 8/24/2560 BE.
//  Copyright © 2560 MuMhu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var alrdy: UIButton!
    var type: String?
    var check: Bool? = false
    var typeAction:UIAlertController!
    @IBOutlet weak var typeBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        let attributedString = NSAttributedString(string: "Already Have An Account?", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.underlineStyle:1])
        alrdy.setAttributedTitle(attributedString, for: .normal)
        typeAction = UIAlertController(title: "Choose Your Type", message: "Are You Photographer or model?", preferredStyle: UIAlertControllerStyle.actionSheet)
        let photographerAction = UIAlertAction(title: "Photographer", style: UIAlertActionStyle.default) { (action) in
            self.check = true
            self.type = "photographer"
        }
        let modelAction = UIAlertAction(title: "Model", style: UIAlertActionStyle.default) { (action) in
            self.check = true
            self.type = "model"
        }
        let clientAction = UIAlertAction(title: "Client", style: UIAlertActionStyle.default) { (action) in
            self.check = true
            self.type = "client"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        typeAction.addAction(photographerAction)
        typeAction.addAction(modelAction)
        typeAction.addAction(clientAction)
        typeAction.addAction(cancelAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func typeChooserTapped(_ sender: AnyObject) {
        self.present(typeAction, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SetupUser"){
            let NextViewController = segue.destination as! RegisShooterViewController
            let sendingType = type! as String
            NextViewController.type = sendingType
        }
    }
    
    @IBAction func createAccontTapped(_ sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        Auth.auth().createUser(withEmail: username!, password: password!) { (user, error) in
            if error != nil && self.check == false {
                //error
                
                let errorMessage = (error?.localizedDescription)!
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else if self.check == false{
                let errorMessage = "Please chose your type."
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else
                {
                //succress
                self.performSegue(withIdentifier: "SetupUser", sender: self.type)            }
        }
        
    }
    

}
