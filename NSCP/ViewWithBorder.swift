//
//  ViewWithBorder.swift
//  NSCP
//
//  Created by MuMhu on 10/27/2560 BE.
//  Copyright © 2560 MuMhu. All rights reserved.
//

import UIKit

class ViewWithBorder: UIView {

    override func layoutSubviews() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
    }

}
