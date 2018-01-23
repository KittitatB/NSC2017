//
//  MessageCollectionCell.swift
//  NSCP
//
//  Created by MuMhu on 1/16/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit

class MessageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var bubbleviewLeftAnchor: NSLayoutConstraint!
    @IBOutlet weak var bubbleviewRightAnchor: NSLayoutConstraint!
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var bubbleview: UIView!
    @IBOutlet weak var bubbleWidth: NSLayoutConstraint!
    @IBOutlet weak var textview: UITextView!
}
