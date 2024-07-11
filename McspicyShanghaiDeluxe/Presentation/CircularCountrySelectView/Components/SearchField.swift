//
//  SearchField.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/11/24.
//

import UIKit

final class SearchField: UITextField {
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        return button
    }()
    
    private lazy var searchIcon: UIImageView = {
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .secondaryTextColor
        
        return searchIcon
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
        switchCornerRadius(by: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.leftViewRect(forBounds: bounds)
        padding.origin.x += 10
        return padding
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.insetBy(dx: 10, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.insetBy(dx: 10, dy: 10)
    }
    
    private func configureUI() {
        backgroundColor = .darkGray
        
        textColor = .white
        
        leftView = searchIcon
        leftViewMode = .always
        
        clearButtonMode = .whileEditing
    }
    
    func leftViewWidth() -> CGFloat {
        let contentSize = leftView?.intrinsicContentSize ?? .zero
        return contentSize.width + 20
    }
    
    func switchCornerRadius(by isHighlighted: Bool) {
        layer.cornerRadius = 10
        if isHighlighted {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        }
    }
}
