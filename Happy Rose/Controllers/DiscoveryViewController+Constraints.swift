//
//  DiscoveryViewController+Constraints.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/22/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit
import SnapKit

extension DiscoveryViewController {
    
    func setupConstraints() {
        let kFilterViewTopPadding: CGFloat = -3
        let kFilterViewHorizontalPadding: CGFloat = 19
        
        priceFilterView.snp.makeConstraints { (make) in
            make.top.equalTo(priceFilterButton.snp.top).offset(kFilterViewTopPadding)
            make.left.equalToSuperview().offset(kFilterViewHorizontalPadding)
            make.right.equalToSuperview().offset(-kFilterViewHorizontalPadding)
        }
        
        colorFilterView.snp.makeConstraints { (make) in
            make.top.equalTo(priceFilterButton.snp.top).offset(kFilterViewTopPadding)
            make.left.equalToSuperview().offset(kFilterViewHorizontalPadding)
            make.right.equalToSuperview().offset(-kFilterViewHorizontalPadding)
        }
        
        flowersFilterView.snp.makeConstraints { (make) in
            make.top.equalTo(priceFilterButton.snp.top).offset(kFilterViewTopPadding)
            make.left.equalToSuperview().offset(kFilterViewHorizontalPadding)
            make.right.equalToSuperview().offset(-kFilterViewHorizontalPadding)
        }
        
        occasionFilterView.snp.makeConstraints { (make) in
            make.top.equalTo(priceFilterButton.snp.top).offset(kFilterViewTopPadding)
            make.left.equalToSuperview().offset(kFilterViewHorizontalPadding)
            make.right.equalToSuperview().offset(-kFilterViewHorizontalPadding)
        }
    }
    
    func addEmptyStateConstraint() {
        guard emptyStateView.superview != nil else {
            return
        }
        
        DispatchQueue.once(token: "com.happyRose.discoveryViewController.addEmptyStateConstraint") {
            emptyStateView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview()
            }
        }
    }
}
