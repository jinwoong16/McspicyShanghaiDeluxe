//
//  CountrySearchView.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/11/24.
//

import UIKit

final class CountrySearchView: UIView {
    private(set) lazy var searchBackgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let searchBackgroundView = IntensityVisualEffectView(
            effect: blurEffect,
            intensity: 0.35
        )
        searchBackgroundView.frame = bounds
        searchBackgroundView.isHidden = true
        
        return searchBackgroundView
    }()
    
    private lazy var searchBarWidthConstraint = searchBar
        .widthAnchor
        .constraint(
            equalToConstant: searchBar.leftViewWidth()
        )
    private(set) lazy var searchBar: SearchField = {
        let searchBar = SearchField()
        
        return searchBar
    }()
    
    private lazy var searchResultHieghtConstraint = searchResultView
        .heightAnchor
        .constraint(
            equalToConstant: 0
        )
    private(set) lazy var searchResultView: UITableView = {
        let searchResultView = UITableView()
        searchResultView.backgroundColor = .darkGray
        searchResultView.layer.cornerRadius = 10
        searchResultView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        searchResultView.clipsToBounds = true
        searchResultView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return searchResultView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
    
    private func configureUI() {
        addSubview(searchBackgroundView)
        addSubview(searchResultView)
        addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchResultView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchBarWidthConstraint,
            
            searchResultView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchResultView.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchResultView.widthAnchor.constraint(equalToConstant: 300),
            searchResultHieghtConstraint,
        ])
    }
    
    func updateSearchBarWidth(to status: SearchBarStatus) {
        switch status {
        case .initial:
            searchBarWidthConstraint.constant = searchBar.leftViewWidth()
        case let .expanded(width):
            searchBarWidthConstraint.constant = width
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: .zero) {
            self.layoutIfNeeded()
        }
    }
    
    func hideBackgroundView(_ isHidden: Bool) {
        searchBackgroundView.isHidden = isHidden
    }
    
    func updateSearchResultViewHeight(
        by itemCount: Int,
        maxHeight: CGFloat,
        isFullRounded: Bool
    ) {
        let contentHeight = CGFloat(itemCount) * 44
        let newHeight = min(maxHeight, contentHeight)
        searchResultHieghtConstraint.constant = newHeight
        searchResultView.isScrollEnabled = contentHeight > maxHeight
        
        if !isFullRounded {
            searchBar.applyCornerRadius(to: .up)
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: .zero) {
            if itemCount != 0 {
                self.layoutIfNeeded()
            }
        } completion: { _ in
            if isFullRounded {
                self.searchBar.applyCornerRadius(to: .full)
            }
        }
    }
    
    func updateSearchResultViewHeight() {
        searchResultHieghtConstraint.constant = 0
        searchResultView.isScrollEnabled = false
        searchBar.applyCornerRadius(to: .full)
    }
}

extension CountrySearchView {
    enum SearchBarStatus {
        case initial
        case expanded(CGFloat)
    }
}
