//
//  HRDiscoveryDetailViewController.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/24/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit
import SnapKit

protocol DiscoveryDetailDelegate {
    func shouldDismissDiscoveryDetailViewController(_ discoveryDetailViewController: HRDiscoveryDetailViewController)
}

class HRDiscoveryDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var item: Item!
    
    var delegate: DiscoveryDetailDelegate!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    init(item: Item) {
        super.init(nibName: nil, bundle: nil)
        self.item = item
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y > 100
    }
    
    override func viewDidLoad() {
        super.loadView()
        
        view.backgroundColor = .backgroundgray
        
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(scrollView)
            make.width.equalTo(view)
        }
        
        let imageContainerView = UIView()
        imageContainerView.backgroundColor = .white
        contentView.addSubview(imageContainerView)
        imageContainerView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.width.equalTo(view.snp.width)
        }
        
        let vc = HRImageCarouselViewController(item: item)
        addChild(vc)
        imageContainerView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        let exitButton = UIButton(type: .custom)
        exitButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        exitButton.setImage(UIImage(named: "xIcon"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(34)
            make.right.equalToSuperview().offset(-3)
        }
        
        let itemPriceLabel = UILabel()
        itemPriceLabel.text = "$\(item.price)"
        itemPriceLabel.font = UIFont(name: "Avenir-Black", size: 20)
        itemPriceLabel.textColor = .outdoorVoices
        contentView.addSubview(itemPriceLabel)
        itemPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-19)
            make.top.equalTo(imageContainerView.snp.bottom).offset(22)
        }
        
        let itemNameLabel = UILabel()
        itemNameLabel.text = item.itemName
        itemNameLabel.font = UIFont(name: "Avenir-Black", size: 20)
        itemNameLabel.textColor = .outdoorVoices
        itemNameLabel.numberOfLines = 0
        contentView.addSubview(itemNameLabel)
        itemNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(19)
            make.right.equalTo(view).offset(-100)
            make.top.equalTo(itemPriceLabel)
        }
        
        let itemDescriptionContainerView = UIView()
        itemDescriptionContainerView.layer.cornerRadius = 20
        itemDescriptionContainerView.backgroundColor = .white
        contentView.addSubview(itemDescriptionContainerView)
        itemDescriptionContainerView.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width)
            make.right.equalTo(view).offset(-19)
            make.top.equalTo(itemNameLabel.snp.bottom).offset(15)
        }
        
        let descTitleLabel = UILabel()
        descTitleLabel.text = "Description"
        descTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        descTitleLabel.textColor = .outdoorVoices
        itemDescriptionContainerView.addSubview(descTitleLabel)
        descTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(48)
        }
        
        let itemDescriptionLabel = UILabel()
        itemDescriptionLabel.text = item.itemDescription
        itemDescriptionLabel.numberOfLines = 0
        itemDescriptionLabel.font = UIFont(name: "Avenir-Book", size: 12)
        itemDescriptionLabel.textColor = .hotStuff
        itemDescriptionContainerView.addSubview(itemDescriptionLabel)
        itemDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descTitleLabel.snp.bottom).offset(3)
            make.bottom.equalToSuperview().offset(-12)
            make.left.equalTo(descTitleLabel)
            make.right.equalToSuperview().offset(-10)
        }
        
//        let careTitleLabel = UILabel()
//        careTitleLabel.text = "Instructions"
//        careTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
//        careTitleLabel.textColor = .outdoorVoices
//        contentView.addSubview(careTitleLabel)
//        careTitleLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(itemDescriptionContainerView.snp.bottom).offset(13)
//            make.left.equalTo(descTitleLabel.snp.left).offset(32)
//        }
//
//        let itemCareLabel = UILabel()
//        itemCareLabel.text = item.itemCare
//        itemCareLabel.font = UIFont(name: "Avenir-Book", size: 12)
//        itemCareLabel.textColor = .hotStuff
//        itemCareLabel.numberOfLines = 0
//        contentView.addSubview(itemCareLabel)
//        itemCareLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(careTitleLabel)
//            make.top.equalTo(careTitleLabel.snp.bottom).offset(3)
//            make.right.equalTo(view).offset(-29)
//        }
//
//        let thermometerIcon = UIImageView(image: UIImage(named: "thermostat"))
//        contentView.addSubview(thermometerIcon)
//        thermometerIcon.snp.makeConstraints { (make) in
//            make.left.equalTo(descTitleLabel)
//            make.centerY.equalTo(itemCareLabel.snp.top)
//        }
        
        let floristDetailsContainerView = UIView()
        floristDetailsContainerView.backgroundColor = .white
        floristDetailsContainerView.isOpaque = true
        floristDetailsContainerView.layer.cornerRadius = 20
        contentView.addSubview(floristDetailsContainerView)
        floristDetailsContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(itemDescriptionContainerView.snp.bottom).offset(25)
            make.left.equalTo(view).offset(19)
            make.right.equalTo(view).offset(-19)
        }
        
        let floristNameRectangle = UIView()
        floristNameRectangle.backgroundColor = .checkbox
        floristNameRectangle.alpha = 0.3
        floristDetailsContainerView.addSubview(floristNameRectangle)
        floristNameRectangle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(26)
            make.centerX.equalToSuperview()
            make.width.equalTo(211)
            make.height.equalTo(10)
        }
        
        let floristNameLabel = UILabel()
        floristNameLabel.text = "HAPPY ROSE FLORIST"
        floristNameLabel.font = UIFont(name: "Avenir-Black", size: 18)
        floristNameLabel.numberOfLines = 0
        floristNameLabel.textAlignment = .center
        floristNameLabel.textColor = .outdoorVoices
        floristDetailsContainerView.addSubview(floristNameLabel)
        floristNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(41)
            make.right.equalToSuperview().offset(-41)
            make.bottom.equalTo(floristNameRectangle).offset(1)
        }
        
        let callButton = HRFloristCTAButton(title: "CALL", imageName: "phone")
        callButton.addTarget(self, action: #selector(callButtonTapped(_:)), for: .touchUpInside)
        floristDetailsContainerView.addSubview(callButton)
        callButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(77)
            make.top.equalTo(floristNameLabel.snp.bottom).offset(15)
            make.right.equalTo(floristDetailsContainerView.snp.centerX).offset(-28)
        }
        
        let directionsButton = HRFloristCTAButton(title: "DIRECTIONS", imageName: "map")
        directionsButton.addTarget(self, action: #selector(directionsButtonTapped(_:)), for: .touchUpInside)
        floristDetailsContainerView.addSubview(directionsButton)
        directionsButton.snp.makeConstraints { (make) in
            make.height.width.top.bottom.equalTo(callButton)
            make.left.equalTo(floristDetailsContainerView.snp.centerX).offset(28)
        }
        
        let lineSpacing: CGFloat = 1
        
        let streetAddressLabel = UILabel.detailLabel(text: "475 N LAKE AVE", textAlignment: .center)
        floristDetailsContainerView.addSubview(streetAddressLabel)
        streetAddressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(callButton.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
        
        let localityAddressLabel = UILabel.detailLabel(text: "PASADENA, CA 91101", textAlignment: .center)
        floristDetailsContainerView.addSubview(localityAddressLabel)
        localityAddressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(streetAddressLabel.snp.bottom).offset(lineSpacing)
            make.centerX.equalToSuperview()
        }
        
        let sundayLabel = UILabel.detailLabel(text: "SUNDAY", textAlignment: .left)
        let mondayLabel = UILabel.detailLabel(text: "MONDAY", textAlignment: .left)
        let tuesdayLabel = UILabel.detailLabel(text: "TUESDAY", textAlignment: .left)
        let wednesdayLabel = UILabel.detailLabel(text: "WEDNESDAY", textAlignment: .left)
        let thursdayLabel = UILabel.detailLabel(text: "THURSDAY", textAlignment: .left)
        let fridayLabel = UILabel.detailLabel(text: "FRIDAY", textAlignment: .left)
        let saturdayLabel = UILabel.detailLabel(text: "SATURDAY", textAlignment: .left)
        
        floristDetailsContainerView.addSubview(sundayLabel)
        floristDetailsContainerView.addSubview(mondayLabel)
        floristDetailsContainerView.addSubview(tuesdayLabel)
        floristDetailsContainerView.addSubview(wednesdayLabel)
        floristDetailsContainerView.addSubview(thursdayLabel)
        floristDetailsContainerView.addSubview(fridayLabel)
        floristDetailsContainerView.addSubview(saturdayLabel)
        
        let sundayHoursLabel = UILabel.detailLabel(text: "10 AM - 6 PM", textAlignment: .right)
        let mondayHoursLabel = UILabel.detailLabel(text: "9 AM - 8 PM", textAlignment: .right)
        let tuesdayHoursLabel = UILabel.detailLabel(text: "9 AM - 8 PM", textAlignment: .right)
        let wednesdayHoursLabel = UILabel.detailLabel(text: "9 AM - 8 PM", textAlignment: .right)
        let thursdayHoursLabel = UILabel.detailLabel(text: "9 AM - 8 PM", textAlignment: .right)
        let fridayHoursLabel = UILabel.detailLabel(text: "9 AM - 8 PM", textAlignment: .right)
        let saturdayHoursLabel = UILabel.detailLabel(text: "9 AM - 8 PM", textAlignment: .right)
        
        floristDetailsContainerView.addSubview(sundayHoursLabel)
        floristDetailsContainerView.addSubview(mondayHoursLabel)
        floristDetailsContainerView.addSubview(tuesdayHoursLabel)
        floristDetailsContainerView.addSubview(wednesdayHoursLabel)
        floristDetailsContainerView.addSubview(thursdayHoursLabel)
        floristDetailsContainerView.addSubview(fridayHoursLabel)
        floristDetailsContainerView.addSubview(saturdayHoursLabel)
        
        sundayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(callButton)
            make.top.equalTo(localityAddressLabel.snp.bottom).offset(13)
        }
        
        sundayHoursLabel.snp.makeConstraints { (make) in
            make.right.equalTo(directionsButton)
            make.top.equalTo(sundayLabel)
        }
        
        mondayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sundayLabel)
            make.top.equalTo(sundayLabel.snp.bottom).offset(1)
        }
        
        mondayHoursLabel.snp.makeConstraints { (make) in
            make.right.equalTo(sundayHoursLabel)
            make.top.equalTo(sundayHoursLabel.snp.bottom).offset(1)
        }
        
        tuesdayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sundayLabel)
            make.top.equalTo(mondayLabel.snp.bottom).offset(1)
        }
        
        tuesdayHoursLabel.snp.makeConstraints { (make) in
            make.right.equalTo(sundayHoursLabel)
            make.top.equalTo(mondayHoursLabel.snp.bottom).offset(1)
        }
        
        wednesdayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sundayLabel)
            make.top.equalTo(tuesdayLabel.snp.bottom).offset(1)
        }
        
        wednesdayHoursLabel.snp.makeConstraints { (make) in
            make.right.equalTo(sundayHoursLabel)
            make.top.equalTo(tuesdayHoursLabel.snp.bottom).offset(1)
        }
        
        thursdayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sundayLabel)
            make.top.equalTo(wednesdayLabel.snp.bottom).offset(1)
        }
        
        thursdayHoursLabel.snp.makeConstraints { (make) in
            make.right.equalTo(sundayHoursLabel)
            make.top.equalTo(wednesdayHoursLabel.snp.bottom).offset(1)
        }
        
        fridayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sundayLabel)
            make.top.equalTo(thursdayLabel.snp.bottom).offset(1)
        }
        
        fridayHoursLabel.snp.makeConstraints { (make) in
            make.right.equalTo(sundayHoursLabel)
            make.top.equalTo(thursdayHoursLabel.snp.bottom).offset(1)
        }
        
        saturdayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(sundayLabel)
            make.top.equalTo(fridayLabel.snp.bottom).offset(1)
        }
        
        saturdayHoursLabel.snp.makeConstraints { (make) in
            make.right.equalTo(sundayHoursLabel)
            make.top.equalTo(fridayHoursLabel.snp.bottom).offset(1)
            make.bottom.equalTo(contentView).offset(-40)
            make.bottom.equalTo(floristDetailsContainerView).offset(-200)
        }
        
        let easterEgg = UILabel.detailLabel(text: "Made with love in LA",
                                            textAlignment: .center,
                                            textColor: .outdoorVoices)
        let loveLabel = UILabel.detailLabel(text: "❤️ Lakil ❤️",
                                            textAlignment: .center,
                                            textColor: .outdoorVoices)
        
        floristDetailsContainerView.addSubview(easterEgg)
        floristDetailsContainerView.addSubview(loveLabel)
        
        easterEgg.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        loveLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(easterEgg.snp.bottom).offset(lineSpacing)
        }
    }
    
    @objc func exitButtonTapped(_ sender: UIButton) {
        delegate.shouldDismissDiscoveryDetailViewController(self)
    }
    
    @objc func callButtonTapped(_ sender: UIButton) {
        let busPhone = "6264400903"
        
        if let url = URL(string: "tel://\(busPhone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func directionsButtonTapped(_ sender: UIButton) {
        let link = "http://maps.google.com/?q=Happy+Rose+Florist"
        
        if let url = URL(string: "\(link)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

