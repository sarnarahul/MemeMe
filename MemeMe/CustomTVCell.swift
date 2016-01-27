//
//  CustomTableViewCell.swift
//
//
//  Created by Rahul Sarna on 8/25/15.
//
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func setTopBottomText(topText: String, bottomText: String){
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)!,
            NSStrokeWidthAttributeName : -2.0
        ]
        
        var topAttributtedText = NSMutableAttributedString(string: topText as String, attributes: memeTextAttributes)
        var bottomAttributtedText = NSMutableAttributedString(string: bottomText as String, attributes: memeTextAttributes)
        
        self.topLabel.attributedText = topAttributtedText
        self.bottomLabel.attributedText = bottomAttributtedText
        
    }

    
}
