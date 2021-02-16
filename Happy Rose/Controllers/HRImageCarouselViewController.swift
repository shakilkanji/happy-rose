//
//  HRImageCarouselViewController.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/25/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit

class HRImageCarouselViewController: UIPageViewController {
    
    var pageItems: [UIViewController] = []
    var pageControl = UIPageControl()
    
    init(item: Item) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
        
        populatePageItems(withItem: item)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self

        if let firstViewController = pageItems.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        setupPageControl()
    }
    
    private func setupPageControl() {
        guard pageItems.count > 1 else {
            view.isUserInteractionEnabled = false
            return
        }
        
        pageControl.numberOfPages = pageItems.count
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    private func populatePageItems(withItem item: Item) {
        for imagePath in item.carouselImagePaths {
            let vc = createCarouselItemController(with: imagePath)
            pageItems.append(vc)
        }
    }
    
    private func createCarouselItemController(with imagePath: String) -> UIViewController {
        let vc = UIViewController()
        let imageView = UIImageView()
        imageView.alpha = 0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        UIImage.fetchImage(forImagePath: imagePath) { (result) in
            if case let .success(image) = result {
                imageView.image = image
                UIView.animate(withDuration: 0.3, animations: {
                    imageView.alpha = 1
                })
                
            }
        }
        
        vc.view = imageView
        return vc
    }
}

extension HRImageCarouselViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = pageItems.firstIndex(of: firstViewController) else {
                return
        }
        
        pageControl.currentPage = firstViewControllerIndex
    }
}

extension HRImageCarouselViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageItems.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pageItems.last
        }
        
        guard pageItems.count > previousIndex else {
            return nil
        }
        
        return pageItems[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageItems.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard pageItems.count != nextIndex else {
            return pageItems.first
        }
        
        guard pageItems.count > nextIndex else {
            return nil
        }
        
        return pageItems[nextIndex]
    }
}
