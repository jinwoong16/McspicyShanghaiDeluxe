//
//  CircularCountrySelectViewController.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/7/24.
//

import UIKit

protocol CountryReceivable: AnyObject {
    func send(country: Country)
}

final class CircularCountrySelectViewController: UIViewController {
    // MARK: - Components
    private lazy var circularContryButtonsView = CircularCountryButtonsView(
        countries: countries,
        currentCountry: currentCountry,
        frame: view.bounds
    )
    
    private lazy var searchBackgroundView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let searchBackgroundView = UIVisualEffectView(effect: blurEffect)
        searchBackgroundView.frame = self.view.bounds
        searchBackgroundView.isHidden = true
        
        return searchBackgroundView
    }()
    
    private lazy var searchBarWidthConstraint = searchBar.widthAnchor.constraint(equalToConstant: 50)
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = .darkGray
        searchBar.searchTextField.leftView?.tintColor = .secondaryTextColor
        
        return searchBar
    }()
    
    private lazy var closeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "xmark")
        configuration.baseForegroundColor = .white
        
        return UIButton(configuration: configuration)
    }()
    
    private lazy var selectButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "변경하기"
        configuration.titlePadding = 20
        configuration.baseBackgroundColor = .addButton
        configuration.baseForegroundColor = .black
        
        return UIButton(configuration: configuration)
    }()
    
    private lazy var feedbackHandler: FeedbackHandler = {
        FeedbackHandler(targetView: view)
    }()
    
    private let countries: [Country]
    private var currentCountry: Country?
    var delegate: CountryReceivable?
    
    init(countries: [Country], currentCountry: Country? = nil) {
        self.countries = countries
        self.currentCountry = currentCountry
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBlurEffect()
        configureUI()
        configureGesture()
        configureButtons()
        
        searchBar.delegate = self
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        self.view.addSubview(blurEffectView)
    }
    
    private func configureUI() {
        view.backgroundColor = .clear
        
        view.addSubview(circularContryButtonsView)
        view.addSubview(closeButton)
        view.addSubview(selectButton)
        
        view.addSubview(searchBackgroundView)
        view.addSubview(searchBar)
        
        circularContryButtonsView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circularContryButtonsView.widthAnchor.constraint(equalTo: view.widthAnchor),
            circularContryButtonsView.heightAnchor.constraint(equalTo: view.heightAnchor),
            circularContryButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularContryButtonsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBarWidthConstraint,
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            selectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            selectButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func configureGesture() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(rotateAction(with:))
        )
        circularContryButtonsView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(resignSearchField)
        )
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureButtons() {
        selectButton
            .addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    self.delegate?.send(country: self.circularContryButtonsView.selectedCountry)
                    self.dismiss(animated: true)
                },
                for: .touchUpInside
            )
        closeButton
            .addAction(
                UIAction { [weak self] _ in
                    self?.dismiss(animated: true)
                },
                for: .touchUpInside
            )
    }
    
    @objc private func rotateAction(with gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if abs(translation.y) > 50 {
            circularContryButtonsView.rotate(
                to: (translation.y > 0 ? .up : .down)
            )
            feedbackHandler.sendFeedback()
            
            gesture.setTranslation(.zero, in: view)
        }
        
        if gesture.state == .ended {
            circularContryButtonsView.updateCheckmark()
        }
    }
    
    @objc private func resignSearchField() {
        searchBar.resignFirstResponder()
    }
}

extension CircularCountrySelectViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarWidthConstraint.constant = 300
        searchBackgroundView.isHidden = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: .zero) {
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarWidthConstraint.constant = 50
        searchBackgroundView.isHidden = true
        searchBar.text = ""
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: .zero) {
            self.view.layoutIfNeeded()
        }
    }
}

}
