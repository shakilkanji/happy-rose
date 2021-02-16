//
//  CALayerExtensions.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/22/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit

extension CALayer {
    
    func applySketchShadow(
        color: UIColor = .shadow,
        alpha: Float = 1,
        x: CGFloat = 1,
        y: CGFloat = 1,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
