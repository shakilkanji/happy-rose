//
//  BaseFilterView.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/22/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit
import SnapKit
import M13Checkbox

enum FilteringType: String {
    case color = "Color"
    case flower = "Flowers"
    case occasion = "Occasion"
}

struct BaseFilterViewVM {
    let filteringType: FilteringType
    
    let availableTags: [Tag]
    let appliedTags: [Tag]
    
    init(filteringType: FilteringType, appliedTags: [Tag]) {
        self.filteringType = filteringType
        
        switch filteringType {
        case .color:
            self.availableTags = [.red, .pink, .yellow, .purple, .white, .orange]
        case .flower:
            self.availableTags = [.rose, .daisy, .lily, .sunflower, .orchid, .iris]
        case .occasion:
            self.availableTags = [.birthday, .love, .congrats, .baby, .hospital, .sympathy]
        }
        
        self.appliedTags = appliedTags
    }
}

class BaseFilterView: UIView {
    
    let kHRBaseFilterViewCellHeight: CGFloat = 57
    let kHRBaseFilterViewCollectionViewHorizontalPadding: CGFloat = 26
    let kHRBaseFilterViewCollectionViewInterItemSpacing: CGFloat = 4
    let kHRBaseFilterViewCollectionViewLineSpacing: CGFloat = 15
    
    var delegate: TagFilterDelegate?
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var viewModel: BaseFilterViewVM {
        didSet {
            collectionView.snp.updateConstraints { (make) in
                let numRows = ceilf(Float(viewModel.availableTags.count) / 2.0)
                let height = Float(kHRBaseFilterViewCellHeight) * numRows
                    + Float(kHRBaseFilterViewCollectionViewLineSpacing) * (numRows - 1)
                make.height.equalTo(height)
            }
            collectionView.reloadData()
        }
    }
    
    var appliedSet = Set<Tag>()
    
    init(frame: CGRect, viewModel: BaseFilterViewVM) {
        self.viewModel = viewModel
        
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.applySketchShadow()
        layer.cornerRadius = 7
        
        let headerLabel = UILabel()
        headerLabel.text = viewModel.filteringType.rawValue
        headerLabel.font = UIFont.avenirHeavy(18)
        headerLabel.textColor = .outdoorVoices
        headerLabel.textAlignment = .center
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = .outdoorVoices
        addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }
        
        let clearButton = UIButton(type: .custom)
        clearButton.backgroundColor = .white
        clearButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16)
        clearButton.setTitleColor(.outdoorVoices, for: .normal)
        clearButton.setTitle("Clear filter", for: .normal)
        clearButton.layer.cornerRadius = 20
        clearButton.layer.borderWidth = 1
        clearButton.layer.borderColor = UIColor.outdoorVoices.cgColor
        addSubview(clearButton)
        
        let applyButton = UIButton(type: .custom)
        applyButton.backgroundColor = .outdoorVoices
        applyButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.setTitle("Apply", for: .normal)
        applyButton.layer.cornerRadius = 20
        addSubview(applyButton)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(BaseFilterViewCell.self, forCellWithReuseIdentifier: "BaseFilterViewCell")
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(separatorLine).offset(21)
            make.left.equalToSuperview().offset(kHRBaseFilterViewCollectionViewHorizontalPadding)
            make.right.equalToSuperview().offset(-kHRBaseFilterViewCollectionViewHorizontalPadding)
            make.bottom.equalTo(clearButton.snp.top).offset(-18)
            make.height.equalTo(kHRBaseFilterViewCellHeight * 3 + kHRBaseFilterViewCollectionViewLineSpacing * 2)
        }

        clearButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(29)
            make.bottom.equalToSuperview().offset(-23)
            make.height.equalTo(40)
        }

        applyButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-29)
            make.top.bottom.equalTo(clearButton)
            make.width.equalTo(clearButton)
            make.left.equalTo(clearButton.snp.right).offset(21)
        }
        
        applyButton.addTarget(self, action: #selector(didTapApply(_:)), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(didTapClearFilter(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapApply(_ sender: UIButton) {
        delegate?.didApplyTags(self, Array(appliedSet))
    }
    
    @objc private func didTapClearFilter(_ sender: UIButton) {
        delegate?.didApplyTags(self, [])
    }
    
    func updateWithViewModel(_ viewModel: BaseFilterViewVM) {
        self.viewModel = viewModel
        self.appliedSet = Set(viewModel.appliedTags)
    }
}

extension BaseFilterView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.availableTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BaseFilterViewCell",
                                                      for: indexPath) as! BaseFilterViewCell
        cell.filterTag = viewModel.availableTags[indexPath.item]
        cell.isActive = viewModel.appliedTags.contains(cell.filterTag)
        return cell
    }
}

extension BaseFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BaseFilterViewCell
        cell.isActive = !cell.isActive
        if appliedSet.contains(cell.filterTag) {
            appliedSet.remove(cell.filterTag)
        } else {
            appliedSet.insert(cell.filterTag)
        }
    }
}

extension BaseFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.frame.width - (kHRBaseFilterViewCollectionViewHorizontalPadding * 2)
            - kHRBaseFilterViewCollectionViewInterItemSpacing) / 2
        return CGSize(width: width, height: kHRBaseFilterViewCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kHRBaseFilterViewCollectionViewInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kHRBaseFilterViewCollectionViewLineSpacing
    }
}

class BaseFilterViewCell: UICollectionViewCell {
    
    let label = UILabel()
    let checkbox = M13Checkbox()
    var filterTag: Tag! {
        didSet {
            label.text = filterTag.format()
        }
    }
    
    var isActive: Bool = false {
        didSet {
            backgroundColor = isActive ? .theLatestGray : .white
            let checkState: M13Checkbox.CheckState = isActive ? .checked : .unchecked
            checkbox.setCheckState(checkState, animated: true)
            label.textColor = isActive ? .outdoorVoices : .hotStuff
            label.font = isActive ? UIFont.avenirHeavy(16) : UIFont.avenirMedium(16)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 3
        
        label.font = UIFont(name: "Avenir-Book", size: 16)
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(51)
            make.centerY.equalToSuperview()
        }
        
        checkbox.tintColor = .checkbox
        checkbox.stateChangeAnimation = .flat(.fill)
        checkbox.animationDuration = 0.2
        checkbox.isUserInteractionEnabled = false
        addSubview(checkbox)
        checkbox.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
