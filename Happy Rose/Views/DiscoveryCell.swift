//
//  DiscoveryCell.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/15/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit

class DiscoveryCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemPriceLabel: UILabel!
    @IBOutlet var borderView: UIView!
    
    override func awakeFromNib() {
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.outdoorVoices.cgColor
        
        borderView.layer.cornerRadius = 3
        borderView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.layer.cornerRadius = 3
    }
    
    var item: Item? {
        didSet {
            if let item = item {
                setupCell(with: item)
            }
        }
    }
    
    private func setupCell(with item: Item) {
        itemNameLabel.text = item.itemName
        itemPriceLabel.text = "$\(item.price)"
        
        imageView.alpha = 0
        
        UIImage.fetchImage(for: item, sizeForWidth: self.imageView.frame.size.width) { (result) in
            guard item.imagePath == self.item?.imagePath else {
                return
            }
            
            if case let .success(image) = result {
                self.imageView.image = image
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.imageView.alpha = 1
                })
            }
        }
    }
}
