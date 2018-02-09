//
//  CommentCollectionViewCell.swift
//  NSCP
//
//  Created by MuMhu on 2/9/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var commenterImage: UIImageView!
    
    @IBOutlet weak var bubbleTextview: UIView!
    
    @IBOutlet weak var commentTextview: UITextView!
    
    
    @IBOutlet weak var bubbleWidth: NSLayoutConstraint!
}
