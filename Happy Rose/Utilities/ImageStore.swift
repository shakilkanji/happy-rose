//
//  ImageStore.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 7/26/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit

class ImageStore {
    
    static let sharedInstance = ImageStore()
    
    let cache = NSCache<NSString,UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        
        if let data = image.jpegData(compressionQuality: 1) {
            do {
                try data.write(to: url, options: [.atomic])
            } catch let setImageError {
                print("Failed to set image with error:\(setImageError)")
            }
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        if let cachedImage = cache.object(forKey: key as NSString) {
            return cachedImage
        }
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
}
