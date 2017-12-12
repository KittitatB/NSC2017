//
//  ModelTableViewCell.swift
//  NSCP
//
//  Created by MuMhu on 11/14/2560 BE.
//  Copyright © 2560 MuMhu. All rights reserved.
//

import UIKit

class ModelTableViewCell: UITableViewCell {

    @IBOutlet weak var modelName: UILabel!
    @IBOutlet weak var modelImage: CircleImageView!
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
