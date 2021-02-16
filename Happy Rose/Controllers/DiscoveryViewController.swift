//
//  ViewController.swift
//  Happy Rose
//
//  Created by Shakil Kanji on 8/15/19.
//  Copyright © 2019 Plant Labs. All rights reserved.
//

import UIKit
import RangeSeekSlider
import EmptyDataSet_Swift

class DiscoveryViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var priceFilterButton: FilterButton!
    @IBOutlet var colorFilterButton: FilterButton!
    @IBOutlet var flowersFilterButton: FilterButton!
    @IBOutlet var occasionFilterButton: FilterButton!
    @IBOutlet var filterDescriptionLabel: UILabel!
    
    // Filter Views
    let priceFilterView = PriceFilterView(frame: .zero).loadNib() as! PriceFilterView
    let colorFilterView = BaseFilterView(frame: .zero,
                                         viewModel: BaseFilterViewVM(filteringType: .color, appliedTags: []))
    let flowersFilterView = BaseFilterView(frame: .zero,
                                           viewModel: BaseFilterViewVM(filteringType: .flower, appliedTags: []))
    let occasionFilterView = BaseFilterView(frame: .zero,
                                            viewModel: BaseFilterViewVM(filteringType: .occasion, appliedTags: []))
    
    var emptyStateView = HRCollectionEmptyStateView()
    
    // Filter Views - View Model
    private var priceFilterViewVM = PriceFilterViewVM(minPrice: kHRPriceFilterSliderMinValue,
                                                      maxPrice: kHRPriceFilterSliderMaxValue) {
        didSet {
            // Filter and reload collection view
            refreshContent()
        }
    }
    
    private var colorFilterViewVM = BaseFilterViewVM(filteringType: .color, appliedTags: []) {
        didSet {
            refreshContent()
        }
    }
    
    private var flowersFilterViewVM = BaseFilterViewVM(filteringType: .flower, appliedTags: []) {
        didSet {
            refreshContent()
        }
    }
    
    private var occasionFilterViewVM = BaseFilterViewVM(filteringType: .occasion, appliedTags: []) {
        didSet {
            refreshContent()
        }
    }
    
    // Items
    private var items: [Item]? = nil
    private var filteredItems: [Item] = [Item]() {
        didSet {
            let layout = collectionView.collectionViewLayout as! PinterestLayout
            layout.updateLayout()
            
            collectionView.reloadData()
            collectionView.setContentOffset(.zero, animated: false)
        }
    }
    
    // API
    let api = HappyRoseAPI()
    
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        emptyStateView.delegate = self
        emptyStateView.viewState = .loading
        
        priceFilterButton.addTarget(self, action: #selector(didTapFilter(_:)), for: .touchUpInside)
        colorFilterButton.addTarget(self, action: #selector(didTapFilter(_:)), for: .touchUpInside)
        flowersFilterButton.addTarget(self, action: #selector(didTapFilter(_:)), for: .touchUpInside)
        occasionFilterButton.addTarget(self, action: #selector(didTapFilter(_:)), for: .touchUpInside)
        
        priceFilterView.delegate = self
        priceFilterView.alpha = 0
        view.addSubview(priceFilterView)
        
        colorFilterView.delegate = self
        colorFilterView.alpha = 0
        view.addSubview(colorFilterView)
        
        flowersFilterView.delegate = self
        flowersFilterView.alpha = 0
        view.addSubview(flowersFilterView)
        
        occasionFilterView.delegate = self
        occasionFilterView.alpha = 0
        view.addSubview(occasionFilterView)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideFilters))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        setupConstraints()
        
        fetchItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addEmptyStateConstraint()
    }
    
    func fetchItems() {
        api.allItemsAsync {
            (result) in
            
            switch result {
            case let .success(items):
                self.items = items
                self.filteredItems = items
                self.emptyStateView.viewState = .emptyDataSet
            case let .error(error):
                print(error)
                self.emptyStateView.viewState = .downloadError
            }
        }
    }
    
    @objc private func didTapFilter(_ sender: FilterButton) {
        toggleFilter(sender)
    }
    
    private func toggleFilter(_ sender: FilterButton) {
        let animateIn: UIView?
        if sender === priceFilterButton {
            animateIn = priceFilterView
            priceFilterView.updateWithViewModel(priceFilterViewVM)
        } else if sender === colorFilterButton {
            animateIn = colorFilterView
            colorFilterView.updateWithViewModel(colorFilterViewVM)
        } else if sender === flowersFilterButton {
            animateIn = flowersFilterView
            flowersFilterView.updateWithViewModel(flowersFilterViewVM)
        } else if sender === occasionFilterButton {
            animateIn = occasionFilterView
            occasionFilterView.updateWithViewModel(occasionFilterViewVM)
        } else {
            preconditionFailure("Unexpected sender calling toggleFilter(_:)")
        }
        
        UIView.animate(withDuration: 0.2) {
            animateIn?.alpha = 1
            self.collectionView.alpha = 0.5
        }
    }
    
    private func resetContent() {
        filterContent()
        
        priceFilterViewVM = PriceFilterViewVM(minPrice: kHRPriceFilterSliderMinValue,
                                              maxPrice: kHRPriceFilterSliderMaxValue)
        colorFilterViewVM = BaseFilterViewVM(filteringType: .color, appliedTags: [])
        flowersFilterViewVM = BaseFilterViewVM(filteringType: .flower, appliedTags: [])
        occasionFilterViewVM = BaseFilterViewVM(filteringType: .occasion, appliedTags: [])
    }
    
    private func refreshContent() {
        let minPrice = priceFilterViewVM.minPrice
        let maxPrice = priceFilterViewVM.maxPrice
        let appliedColorTags = colorFilterViewVM.appliedTags
        let appliedFlowerTags = flowersFilterViewVM.appliedTags
        let appliedOccasionTags = occasionFilterViewVM.appliedTags
        
        filterContent(minPrice: minPrice,
                      maxPrice: maxPrice,
                      colorTags: appliedColorTags,
                      flowerTags: appliedFlowerTags,
                      occasionTags: appliedOccasionTags)
    }
    
    private func filterContent(minPrice: CGFloat = kHRPriceFilterSliderMinValue,
                               maxPrice: CGFloat = kHRPriceFilterSliderMaxValue,
                               colorTags: [Tag] = [],
                               flowerTags: [Tag] = [],
                               occasionTags: [Tag] = []) {
        guard let items = items else { return }
        var filteringItems = items
        
        filteringItems = filteringItems.filter({ (item) -> Bool in
            return item.price >= Int(minPrice) && item.price <= Int(maxPrice)
        })
        
        if colorTags.count != 0 {
            filteringItems = filter(filteringItems, forTags: colorTags)
        }
        
        if flowerTags.count != 0 {
            filteringItems = filter(filteringItems, forTags: flowerTags)
        }
        
        if occasionTags.count != 0 {
            filteringItems = filter(filteringItems, forTags: occasionTags)
        }
        
        filteredItems = filteringItems
        
        // Update top buttons
        if minPrice != kHRPriceFilterSliderMinValue || maxPrice != kHRPriceFilterSliderMaxValue {
            priceFilterButton.isFilterActive = true
        } else {
            priceFilterButton.isFilterActive = false
        }
        colorFilterButton.isFilterActive = !colorTags.isEmpty
        flowersFilterButton.isFilterActive = !flowerTags.isEmpty
        occasionFilterButton.isFilterActive = !occasionTags.isEmpty
    }
    
    private func filter(_ array: [Item], forTags tags: [Tag]) -> [Item] {
        return array.filter { (item) -> Bool in
            for tag in tags {
                if item.tags.contains(tag.rawValue) {
                    return true
                }
            }
            return false
        }
    }
    
    @objc private func hideFilters() {
        UIView.animate(withDuration: 0.2) {
            self.priceFilterView.alpha = 0
            self.colorFilterView.alpha = 0
            self.flowersFilterView.alpha = 0
            self.occasionFilterView.alpha = 0
            self.collectionView.alpha = 1
        }
    }
}

extension DiscoveryViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        guard collectionView.alpha != 1 else {
            return false
        }
        
        if let touchedView = touch.view {
            return touchedView == view ||
                touchedView.isDescendant(of: collectionView) ||
                touchedView == emptyStateView
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // TODO: fix bug where user can tap solutionButton while a filter view is open
        return true
    }
}

extension DiscoveryViewController: PriceFilterDelegate {
    func didApplyPriceFilter(_ minPrice: CGFloat, _ maxPrice: CGFloat) {
        // Update view model
        priceFilterViewVM = PriceFilterViewVM(minPrice: minPrice, maxPrice: maxPrice)
        hideFilters()
    }
}

extension DiscoveryViewController: TagFilterDelegate {
    func didApplyTags(_ sender: UIView, _ tags: [Tag]) {
        // Update view model
        if sender === colorFilterView {
            colorFilterViewVM = BaseFilterViewVM(filteringType: .color, appliedTags: tags)
        } else if sender === flowersFilterView {
            flowersFilterViewVM = BaseFilterViewVM(filteringType: .flower, appliedTags: tags)
        } else if sender === occasionFilterView {
            occasionFilterViewVM = BaseFilterViewVM(filteringType: .occasion, appliedTags: tags)
        }
        hideFilters()
    }
}

extension DiscoveryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoveryCell", for: indexPath)
        if let discoveryCell = cell as? DiscoveryCell {
            discoveryCell.item = filteredItems[indexPath.item]
        }
        return cell
    }
}

extension DiscoveryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = filteredItems[indexPath.item]
        let detailVC = HRDiscoveryDetailViewController(item: item)
        detailVC.delegate = self
        
        present(detailVC, animated: true, completion: nil)
    }
}

extension DiscoveryViewController: DiscoveryDetailDelegate {
    func shouldDismissDiscoveryDetailViewController(_ discoveryDetailViewController: HRDiscoveryDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension DiscoveryViewController: PinterestLayoutDelegate {
    
    func numberOfItemsInCollectionView(_ collectionView:UICollectionView) -> Int {
        return filteredItems.count
    }

    // 1. Returns the photo height
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
        let item = filteredItems[indexPath.item]
        return CGSize(width: item.imageWidth, height: item.imageHeight)
    }
}

extension DiscoveryViewController: EmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        return emptyStateView
    }
}

extension DiscoveryViewController: EmptyDataSetDelegate {
    func emptyDataSetDidAppear(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.3) {
            self.filterDescriptionLabel.alpha = 0
        }
    }
    
    func emptyDataSetDidDisappear(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.3) {
            self.filterDescriptionLabel.alpha = 1
        }
    }
}

extension DiscoveryViewController: HRCollectionEmptyStateViewDelegate {
    
    func didTapSolutionButtonForViewState(_ viewState: HRCollectionEmptyStateViewState) {
        switch viewState {
        case .downloadError:
            fetchItems()
            emptyStateView.viewState = .loading
        case .loading:
            preconditionFailure("Button should not be available in loading state.")
        case .emptyDataSet:
            resetContent()
        }
    }
}
