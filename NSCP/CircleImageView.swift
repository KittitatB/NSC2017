//
//  CircleImageView.swift
//  NSCP
//
//  Created by MuMhu on 10/22/2560 BE.
//  Copyright © 2560 MuMhu. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        
    }

}
