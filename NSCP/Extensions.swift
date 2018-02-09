//
//  Extensions.swift
//  NSCP
//
//  Created by MuMhu on 1/16/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    func loadImageUsingCacheUsingImageName(imageName: String){
        
        if let cacheImage = imageCache.object(forKey: imageName as AnyObject){
            self.image = cacheImage as? UIImage
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { // 1
            let imageRef = Storage.storage().reference().child("userPic/\(imageName)")
            DispatchQueue.main.async { // 2
                imageRef.getData(maxSize: 25*1024*1024, completion: {(data, error) -> Void in
                    if error == nil{
                        if let downloadedImage = UIImage(data: data!){
                            imageCache.setObject(downloadedImage, forKey: imageName as AnyObject)
                            self.image = downloadedImage
                        }
                    }else {
                        print("Error downloading image: \(error?.localizedDescription)")
                    }
                    
                })
            }
        }
    }
    
    func loadPostImageUsingCacheUsingImageName(imageName: String){
        
        if let cacheImage = imageCache.object(forKey: imageName as AnyObject){
            self.image = cacheImage as? UIImage
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { // 1
            let imageRef = Storage.storage().reference().child("images/\(imageName)")
            DispatchQueue.main.async { // 2
                imageRef.getData(maxSize: 25*1024*1024, completion: {(data, error) -> Void in
                    if error == nil{
                        if let downloadedImage = UIImage(data: data!){
                            imageCache.setObject(downloadedImage, forKey: imageName as AnyObject)
                            self.image = downloadedImage
                        }
                    }else {
                        print("Error downloading image: \(error?.localizedDescription)")
                    }
                    
                })
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
