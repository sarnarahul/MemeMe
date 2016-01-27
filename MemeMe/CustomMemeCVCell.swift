//
//  CustomMemeCollectionViewCell.swift
//
//
//  Created by Rahul Sarna on 8/23/15.
//
//

import UIKit

class CustomMemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    func setTopBottomText(topText: String, bottomText: String){
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)!,
            NSStrokeWidthAttributeName : -2.0
        ]
        
        var topAttributtedText = NSMutableAttributedString(string: topText as String, attributes: memeTextAttributes)
        var bottomAttributtedText = NSMutableAttributedString(string: bottomText as String, attributes: memeTextAttributes)
        
        self.topText.attributedText = topAttributtedText
        self.bottomText.attributedText = bottomAttributtedText
        
    }
    
}
