//
//  CommentTableViewCell.swift
//  NSCP
//
//  Created by MuMhu on 2/10/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentImage: CircleImageView!
    @IBOutlet weak var commentName: UILabel!
    
    @IBOutlet weak var commentTextview: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
