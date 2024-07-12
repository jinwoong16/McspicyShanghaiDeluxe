//
//  SearchField.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/11/24.
//

import UIKit

final class SearchField: UITextField {
    private lazy var searchIcon: UIImageView = {
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .secondaryTextColor
        
        return searchIcon
    }()
    
    private lazy var underlineLayer: CALayer = {
        let underlineLayer = CALayer()
        underlineLayer.backgroundColor = UIColor.searchTextFieldBottomLine.cgColor
        underlineLayer.frame = CGRectMake(0, 0, 0, 1)
        underlineLayer.isHidden = true
        
        return underlineLayer
    }()
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
        applyCornerRadius(to: .full)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        underlineLayer.frame = CGRectMake(0, bounds.height, bounds.width, 1)
            .insetBy(dx: 15, dy: 0)
    }
    
    private func configureUI() {
        backgroundColor = .darkGray
        
        textColor = .white
        
        leftView = searchIcon
        leftViewMode = .always
        
        clearButtonMode = .whileEditing
        
        layer.addSublayer(underlineLayer)
    }

    func leftViewWidth() -> CGFloat {
        let contentSize = leftView?.intrinsicContentSize ?? .zero
        return contentSize.width + 20
    }
    
    func applyCornerRadius(to direction: CornerDirection) {
        layer.cornerRadius = 10
        layer.maskedCorners = direction.maskedCorner
    }
    
    func hideUnderline(_ isHidden: Bool) {
        underlineLayer.isHidden = isHidden
    }
}

extension SearchField {
    enum CornerDirection {
        case up
        case down
        case full
        
        var maskedCorner: CACornerMask {
            switch self {
            case .up:
                return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .down:
                return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .full:
                return CACornerMask(arrayLiteral: [CornerDirection.up.maskedCorner, CornerDirection.down.maskedCorner])
            }
        }
    }
}
