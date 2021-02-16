//
//  StyleFilterView.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/22/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit
import M13Checkbox

protocol TagFilterDelegate {
    func didApplyTags(_ sender: UIView,_ tags: [Tag])
}

struct StyleFilterViewVM {
    let appliedTags: [Tag]
}

@IBDesignable
class StyleFilterView: UIView {
    
    var delegate: TagFilterDelegate?
    
    @IBOutlet var arrangementsView: StyleFilterViewCell!
    @IBOutlet var bouquetsView: StyleFilterViewCell!
    
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
        
        applyButton.addTarget(self, action: #selector(didTapApply(_:)), for: .touchUpInside)
        clearFilterButton.addTarget(self, action: #selector(didTapClearFilter(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapApply(_ sender: UIButton) {
        var styles = [Tag]()
        if arrangementsView.isActive {
            styles.append(.arrangement)
        }
        if bouquetsView.isActive {
            styles.append(.bouquet)
        }
        
        delegate?.didApplyTags(self, styles)
    }
    
    @objc private func didTapClearFilter(_ sender: UIButton) {
        arrangementsView.isActive = false
        bouquetsView.isActive = false
        delegate?.didApplyTags(self, [])
    }
    
    func updateWithViewModel(_ viewModel: StyleFilterViewVM) {
        arrangementsView.isActive = viewModel.appliedTags.contains(.arrangement)
        bouquetsView.isActive = viewModel.appliedTags.contains(.bouquet)
    }
}

class StyleFilterViewCell: UIView {
    
    let checkbox = M13Checkbox()
    let styleNameLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if tag == 0 {
            styleNameLabel.text = "Arrangements"
        } else if tag == 1 {
            styleNameLabel.text = "Bouquets"
        } else {
            preconditionFailure("Unknown tag for StyleFilterViewCell")
        }
        
        var descriptionLabel: UIView?
        for view in subviews {
            if view.tag == 69 {
                descriptionLabel = view
            }
        }
        guard let label = descriptionLabel else {
            fatalError("Hack didn't work to find label based on tag")
        }
        
        styleNameLabel.textColor = .hotStuff
        styleNameLabel.font = UIFont.avenirMedium(16)
        addSubview(styleNameLabel)
        styleNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(29)
            make.bottom.equalTo(label.snp.top).offset(-11.5)
        }
        
        
        checkbox.tintColor = .checkbox
        checkbox.stateChangeAnimation = .flat(.fill)
        checkbox.animationDuration = 0.2
        checkbox.isUserInteractionEnabled = false
        addSubview(checkbox)
        checkbox.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
    }
    
    override func awakeFromNib() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCell(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapCell(_ sender: UITapGestureRecognizer) {
        isActive = !isActive
    }
    
    var isActive: Bool = false {
        didSet {
            backgroundColor = isActive ? .theLatestGray : .white
            let checkState: M13Checkbox.CheckState = isActive ? .checked : .unchecked
            checkbox.setCheckState(checkState, animated: true)
            styleNameLabel.textColor = isActive ? .outdoorVoices : .hotStuff
            styleNameLabel.font = isActive ? UIFont.avenirHeavy(16) : UIFont.avenirMedium(16)
        }
    }
    
}
