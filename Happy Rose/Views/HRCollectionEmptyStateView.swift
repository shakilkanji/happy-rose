//
//  HRCollectionEmptyStateView.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/26/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit
import SnapKit

enum HRCollectionEmptyStateViewState {
    case loading
    case emptyDataSet
    case downloadError
}

protocol HRCollectionEmptyStateViewDelegate {
    func didTapSolutionButtonForViewState(_ viewState: HRCollectionEmptyStateViewState)
}

class HRCollectionEmptyStateView: UIView {
    private let findingYouFlowers = "Finding you the best flowers..."
    private let holdOnTight = "Hold on tight!"
    private let noResults = "Aw Man, No Results"
    private let adjustFilters = "Try adjusting your search by removing filters"
    private let downloadErrorTitle = "Something went wrong..."
    private let downloadErrorDescription = "We had trouble loading flowers for you."
    
    private let emptyDataSetSolution = "CLEAR ALL FILTERS"
    private let downloadErrorSolution = "TRY AGAIN"
    
    var viewState: HRCollectionEmptyStateViewState = .loading {
        didSet {
            switch viewState {
            case .loading:
                awManLabel.text = findingYouFlowers
                fixUrShitLabel.text = holdOnTight
                
                solutionButton.alpha = 0
            case .emptyDataSet:
                awManLabel.text = noResults
                fixUrShitLabel.text = adjustFilters
                
                solutionButton.setTitle(emptyDataSetSolution, for: .normal)
                solutionButton.alpha = 1
                
            case .downloadError:
                awManLabel.text = downloadErrorTitle
                fixUrShitLabel.text = downloadErrorDescription
                
                solutionButton.setTitle(downloadErrorSolution, for: .normal)
                solutionButton.alpha = 1
            }
        }
    }
    
    private let awManLabel = UILabel()
    private let fixUrShitLabel = UILabel()
    private let solutionButton = UIButton(type: .custom)
    
    var delegate: HRCollectionEmptyStateViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let roseImageView = UIImageView(image: UIImage(named: "EmptyRose"))
        addSubview(roseImageView)
        roseImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        awManLabel.text = findingYouFlowers
        awManLabel.font = UIFont.avenirBlack(24)
        awManLabel.numberOfLines = 0
        awManLabel.textAlignment = .center
        awManLabel.textColor = .charcoal
        addSubview(awManLabel)
        awManLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(roseImageView.snp.bottom).offset(17)
        }
        
        fixUrShitLabel.text = holdOnTight
        fixUrShitLabel.font = UIFont.avenirBook(14)
        fixUrShitLabel.textColor = .charcoal
        fixUrShitLabel.numberOfLines = 0
        fixUrShitLabel.textAlignment = .center
        addSubview(fixUrShitLabel)
        fixUrShitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(awManLabel)
            make.centerX.equalToSuperview()
            make.top.equalTo(awManLabel.snp.bottom).offset(3)
        }
        
        solutionButton.setTitle(emptyDataSetSolution, for: .normal)
        solutionButton.setTitleColor(.white, for: .normal)
        solutionButton.titleLabel?.font = UIFont.avenirBlack(14)
        solutionButton.layer.cornerRadius = 20
        solutionButton.backgroundColor = .checkbox
        solutionButton.addTarget(self, action: #selector(solutionButtonPressed(_:)), for: .touchUpInside)
        addSubview(solutionButton)
        solutionButton.snp.makeConstraints { (make) in
            make.width.equalTo(184)
            make.height.equalTo(40)
            make.top.equalTo(fixUrShitLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func solutionButtonPressed(_ sender: UIButton) {
        delegate.didTapSolutionButtonForViewState(viewState)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
