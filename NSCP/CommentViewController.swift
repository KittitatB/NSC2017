//
//  CommentViewController.swift
//  NSCP
//
//  Created by MuMhu on 2/9/2561 BE.
//  Copyright © 2561 MuMhu. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var commendTextField: UITextField!
    @IBOutlet weak var collectionview: UICollectionView!
    var comments = [Commend]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = comments[indexPath.item].text{
            height = estimateFrameForText(text: text).height + 12
            if height < 32{
                height = 32
            }
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16
            )], context: nil)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath as IndexPath) as! CommentCollectionViewCell
        let comment = comments[indexPath.item]
        cell.bubbleTextview.translatesAutoresizingMaskIntoConstraints = false
        cell.commentTextview.translatesAutoresizingMaskIntoConstraints = false
        cell.bubbleWidth.constant = (estimateFrameForText(text: comment.text!).width + 20)
        cell.bubbleTextview.layer.cornerRadius = 16
        cell.bubbleTextview.layer.masksToBounds = true
        cell.commentTextview.text = comment.text
        cell.commentTextview.isEditable = false
        cell.commentTextview.isScrollEnabled = false
        return cell
    }

    @IBAction func commentDidPress(_ sender: Any) {
        
    }
 
}
