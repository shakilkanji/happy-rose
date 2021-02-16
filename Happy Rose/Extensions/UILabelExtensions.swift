//
//  UILabelExtensions.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/25/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit

extension UILabel {
    
    static func detailBaseLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .hotStuff
        label.font = UIFont(name: "Avenir-Roman", size: 11)
        
        return label
    }
    
    static func detailLabel(text: String, textAlignment: NSTextAlignment) -> UILabel {
        let baseLabel = detailBaseLabel()
        baseLabel.text = text
        baseLabel.textAlignment = textAlignment
        
        return baseLabel
    }
    
    static func detailLabel(text: String, textAlignment: NSTextAlignment, textColor: UIColor) -> UILabel {
        let baseLabel = detailLabel(text: text, textAlignment: textAlignment)
        baseLabel.textColor = textColor
        
        return baseLabel
    }
    
}
