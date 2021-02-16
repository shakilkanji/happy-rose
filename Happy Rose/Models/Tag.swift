//
//  Tag.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/23/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import Foundation

enum Tag: String {
    case arrangement
    case bouquet
    
    case red
    case pink
    case yellow
    case purple
    case white
    case orange
    
    case rose
    case lily
    case orchid
    case carnation
    case sunflower
    case iris
    case daisy
    
    case birthday
    case love
    case congrats
    case baby
    case hospital
    case sympathy
}

extension Tag {
    
    func format() -> String {
        switch self {
        case .arrangement:
            return "Arrangements"
        case .bouquet:
            return "Bouquets"
        case .rose:
            return "Roses"
        case .lily:
            return "Lilies"
        case .orchid:
            return "Orchids"
        case .carnation:
            return "Carnations"
        case .sunflower:
            return "Sunflowers"
        case .iris:
            return "Irises"
        case .daisy:
            return "Daisies"
        case .birthday:
            return "Birthday"
        case .love:
            return "Love"
        case .congrats:
            return "Congrats"
        case .baby:
            return "New Baby"
        case .hospital:
            return "Get Well"
        case .sympathy:
            return "Sympathy"
        case .red:
            return "Reds"
        case .pink:
            return "Pinks"
        case .yellow:
            return "Yellows"
        case .purple:
            return "Purples"
        case .white:
            return "Whites"
        case .orange:
            return "Oranges"
        }
    }
    
}
