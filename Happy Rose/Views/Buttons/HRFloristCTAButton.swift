//
//  HRFloristCTAButton.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/26/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit
import SnapKit

class HRFloristCTAButton: UIButton {
    
    init(title: String, imageName: String) {
        super.init(frame: .zero)
        
        backgroundColor = .theLatestGray
        layer.cornerRadius = 20
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.avenirMedium(10)
        label.textColor = .checkbox
        label.textAlignment = .center
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-14)
            make.centerX.equalToSuperview()
        }
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(label.snp.top).offset(-5)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
