//
//  PriceFilterView.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/21/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit
import SnapKit
import RangeSeekSlider

protocol PriceFilterDelegate {
    func didApplyPriceFilter(_ minPrice: CGFloat, _ maxPrice: CGFloat)
}

struct PriceFilterViewVM {
    let minPrice: CGFloat
    let maxPrice: CGFloat
}

@IBDesignable
class PriceFilterView: UIView {
    
    var delegate: PriceFilterDelegate?
    
    @IBOutlet var slider: RangeSeekSlider!
    @IBOutlet var clearFilterButton: UIButton!
    @IBOutlet var applyButton: UIButton!
    
    override func awakeFromNib() {
        
        layer.applySketchShadow()
        layer.cornerRadius = 7
        
        clearFilterButton.backgroundColor = .white
        clearFilterButton.layer.cornerRadius = 20
        clearFilterButton.layer.borderWidth = 1
        clearFilterButton.layer.borderColor = UIColor.outdoorVoices.cgColor
        
        applyButton.layer.cornerRadius = 20
        
        slider.numberFormatter.numberStyle = .currency
        slider.labelPadding = 5
        slider.minLabelFont = UIFont(name: "Avenir-Book", size: 18)!
        slider.maxLabelFont = UIFont(name: "Avenir-Book", size: 18)!
        
        applyButton.addTarget(self, action: #selector(didTapApply(_:)), for: .touchUpInside)
        clearFilterButton.addTarget(self, action: #selector(didTapClearFilter(_:)), for: .touchUpInside)
    }
    
    func updateWithViewModel(_ viewModel: PriceFilterViewVM) {
        slider.selectedMinValue = viewModel.minPrice
        slider.selectedMaxValue = viewModel.maxPrice
        slider.layoutSubviews()
    }
    
    @objc private func didTapApply(_ sender: UIButton) {
        delegate?.didApplyPriceFilter(slider.selectedMinValue, slider.selectedMaxValue)
    }
    
    @objc private func didTapClearFilter(_ sender: UIButton) {
        delegate?.didApplyPriceFilter(slider.minValue, slider.maxValue)
    }
}

