//
//  PhotographerTableViewCell.swift
//  NSCP
//
//  Created by MuMhu on 10/27/2560 BE.
//  Copyright © 2560 MuMhu. All rights reserved.
//

import UIKit

class PhotographerTableViewCell: UITableViewCell {

    @IBOutlet weak var photographerName: UILabel!
    @IBOutlet weak var photographerImage: CircleImageView!
    @IBOutlet weak var randomPic1: UIImageView!
    @IBOutlet weak var randomPic2: UIImageView!    
    @IBOutlet weak var randomPic3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

