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
        frame: view.bounds
    )
    
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
    var delegate: CountryReceivable?
    
    init(countries: [Country]) {
        self.countries = countries
        
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
        configureButton()
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
        view.addSubview(selectButton)
        
        circularContryButtonsView.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circularContryButtonsView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            circularContryButtonsView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            circularContryButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularContryButtonsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
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
        view.addGestureRecognizer(panGesture)
    }
    
    private func configureButton() {
        selectButton
            .addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    self.delegate?.send(country: self.circularContryButtonsView.selectedCountry)
                    self.dismiss(animated: true)
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
}