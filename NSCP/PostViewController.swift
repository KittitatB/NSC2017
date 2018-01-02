//
//  PostViewController.swift
//  NSCP
//
//  Created by MuMhu on 10/15/2560 BE.
//  Copyright © 2560 MuMhu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class PostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    var imageFileName = ""
    var uploadCompleted = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func postTapped(_ sender: AnyObject) {
        if uploadCompleted {
            if let uid = Auth.auth().currentUser?.uid {
                if let model = modelTextField.text {
                    if let location = locationTextField.text {
                        if let link = linkTextField.text {
                            if let description = descriptionTextField.text {
                                    let postObject = [
                                        "uid" : uid,
                                        "model" : model,
                                        "location" : location,
                                        "link" : link,
                                        "description" : description,
                                        "image" : imageFileName
                                    ]
                                
                                    Database.database().reference().child("posts").childByAutoId().setValue(postObject);
                                
                                    let alert = UIAlertController(title: "Success", message: "Your post has been sent!", preferredStyle: .alert)
                                    let postAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default) { (action) in
                                       self.navigationController?.popViewController(animated: true)
                                    }
                                    alert.addAction(postAction)
                                    self.present(alert, animated: true, completion: nil)
                                    print("Post to Firebase.")

                            }
                        }
                    }
                }
            }
        }else{
            let alert = UIAlertController(title: "Uploading Image", message: "Try Again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    @IBAction func selectImageTapped(_ sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    

    func uploadImage(image: UIImage){
        uploadCompleted = false
        let randomName = randomStringWithLength(length: 10)
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        self.imageFileName = "\(randomName).jpg"
        let uploadRef = Storage.storage().reference().child("images/\(randomName).jpg")
        
        let uploadTask = uploadRef.putData(imageData!, metadata: nil){metadata,
            error in
            if error == nil{
                print("Sucessfully uploading image.")
                self.imageFileName = "\(randomName).jpg"
                self.uploadCompleted = true
            } else {
                print("error uploading image:\(error?.localizedDescription)")
            }
        }
    }
    
    func randomStringWithLength(length: Int) -> NSString{
        let chracters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: NSMutableString = NSMutableString(capacity: length)
        for i in 0..<length{
            var len = UInt32(chracters.length)
            var rand = arc4random_uniform(len)
            randomString.appendFormat("%C", chracters.character(at: Int(rand)))
            
        }
        return randomString
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //user finished image form photo lib
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.previewImageView.image = pickedImage
            self.selectImageButton.isEnabled = false
            self.selectImageButton.isHidden = true
            uploadImage(image: pickedImage)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    

}
