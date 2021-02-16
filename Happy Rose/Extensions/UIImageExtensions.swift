//
//  UIImageExtensions.swift
//  Grocery Challenge
//
//  Created by Andrew Crookston on 5/14/18.
//  Copyright © 2018 Instacart. All rights reserved.
//

import UIKit

enum UIImageError: Error {
    case invalidData
}

struct ImageRequest: Requests {
    let url: URL
}

extension UIImage {
    // TODO: instead of caching every different size of image, only cache a default size with desired width
    // ...subsequent lookups can resize the image if needed
    
    /*
     Fetches an image from the cache if its available, otherwise makes an async call.
     Resizes the image to its desired width, preserving aspect ratio.
     Stores this resized image in cache, with a key that indicates the width of the image for future lookup.
    */
    static func fetchImage(for item: Item,
                           sizeForWidth width: CGFloat,
                           completion: @escaping (Result<UIImage>) -> Void) {
        let imageKey = item.imagePath
        
        let shouldResize = width != CGFloat(item.imageWidth)
        
        if let image = ImageStore.sharedInstance.image(forKey: imageKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        UIImage.asyncFrom(url: HappyRoseAPI.urlForPath(path: item.imagePath)) { (result) in
            switch result {
            case .success(let image):
                
                if shouldResize == true {
                    DispatchQueue.global(qos: .userInteractive).async {
                        let resizedImage = image.resizedImageFor(targetWidth: width)
                        DispatchQueue.main.async {
                            completion(.success(resizedImage))
                        }
                        DispatchQueue.global(qos: .default).async {
                            ImageStore.sharedInstance.setImage(resizedImage, forKey: imageKey)
                        }
                    }
                } else {
                    ImageStore.sharedInstance.setImage(image, forKey: imageKey)
                    completion(.success(image))
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    static func fetchImage(for item: Item, completion: @escaping (Result<UIImage>) -> Void) {
        fetchImage(for: item, sizeForWidth: CGFloat(item.imageWidth), completion: completion)
    }
    
    static func fetchImage(forImagePath imagePath: String,
                           completion: @escaping (Result<UIImage>) -> Void) {
        let imageKey = imagePath
        
        if let image = ImageStore.sharedInstance.image(forKey: imageKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        UIImage.asyncFrom(url: HappyRoseAPI.urlForPath(path: imagePath)) { (result) in
            
            switch result {
            case .success(let image):
                completion(.success(image))
                DispatchQueue.global(qos: .default).async {
                    ImageStore.sharedInstance.setImage(image, forKey: imageKey)
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    /// Loads an UIImage from internet asynchronously
    private static func asyncFrom(url: URL, service: Service = NetworkService(),
                                  _ completion: @escaping (Result<UIImage>) -> Void) {
        service.get(request: ImageRequest(url: url)) { result in
            switch result {
            case .success(let data):
                asyncFrom(data: data, completion)
            case .error(let error):
                completion(.error(error))
            }
        }
    }

    private static func asyncFrom(data: Data, _ completion: @escaping (Result<UIImage>) -> Void) {
        DispatchQueue.global(qos: .default).async {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.error(UIImageError.invalidData))
                }
            }
        }
    }
    
    private func resizedImageFor(targetWidth:CGFloat) -> UIImage {
        let currentWidth = self.size.width
        
        let scale = targetWidth / currentWidth
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image(actions: { (context) in
            self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        })
        return resizedImage
    }
}
