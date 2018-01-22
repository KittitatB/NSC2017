//
//  Message.swift
//  NSCP
//
//  Created by MuMhu on 1/13/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit
import Firebase
class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    
    func chatPartnerId() -> String? {
        if fromId == Auth.auth().currentUser?.uid{
            return toId
        }else{
            return fromId
        }
    }
    
}

