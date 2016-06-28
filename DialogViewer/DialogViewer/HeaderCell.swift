//
//  HeaderCell.swift
//  DialogViewer
//
//  Created by Lei Zhao on 6/27/16.
//  Copyright © 2016 Lei Zhao. All rights reserved.
//

import UIKit

class HeaderCell: ContentCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1.0)
        
        label.textColor = UIColor.blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func defaultFont() -> UIFont {
        return UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
}
