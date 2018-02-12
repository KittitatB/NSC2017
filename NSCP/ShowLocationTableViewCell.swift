//
//  ShowLocationTableViewCell.swift
//  NSCP
//
//  Created by MuMhu on 2/12/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit

class ShowLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
