//
//  Item.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/15/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit

class Item : NSObject, Codable {
    
    let itemName: String
    let itemDescription: String
    let itemCare: String
    
    let imagePath: String
    let imageWidth: Int
    let imageHeight: Int
    
    let carouselImagePaths: [String]
    
    let price: Int
    
    let tags: Set<String>
}
