//
//  ActivitiesTableViewCell.swift
//  NSCP
//
//  Created by MuMhu on 1/2/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit

class ActivitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var OwnerImage: CircleImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var joined: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
