//
//  FilterButton.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/21/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit
import SnapKit

class FilterButton: UIButton {
    let kHRFilterButtonBorderWidth: CGFloat = 1.5
    
    var filterLabel = UILabel()
    @IBInspectable var filterLabelText: String? {
        didSet {
            filterLabel.text = filterLabelText
        }
    }
    
    override func awakeFromNib() {
        backgroundColor = .white
        
        layer.borderWidth = kHRFilterButtonBorderWidth
        layer.cornerRadius = 18
        layer.borderColor = UIColor.outdoorVoices.cgColor
        
        layer.applySketchShadow(color: .luluGreen, alpha: 0.3, x: 1.5, y: 1.5, blur: 2.2, spread: 0)
        
        filterLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        filterLabel.textColor = .outdoorVoices
        
        addSubview(filterLabel)
        filterLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    var isFilterActive: Bool = false {
        didSet {
            backgroundColor = isFilterActive ? .outdoorVoices : .white
            filterLabel.textColor = isFilterActive ? .white : .outdoorVoices
            layer.borderWidth = isFilterActive ? 0 : kHRFilterButtonBorderWidth
            
            UIView.animate(withDuration: 0.2) {
                self.setNeedsDisplay()
            }
        }
    }
}
