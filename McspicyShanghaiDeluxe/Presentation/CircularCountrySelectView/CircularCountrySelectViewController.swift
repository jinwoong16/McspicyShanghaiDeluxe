//
//  CircularCountrySelectViewController.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/7/24.
//

import UIKit

final class CircularCountrySelectViewController: UIViewController {
    // MARK: - Components
    private lazy var circularContryButtonsView = CircularCountryButtonsView(
        countries: countries
    )
    
    private let countries: [Country]
    
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
        
        configureUI()
        configureGesture()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(circularContryButtonsView)
        
        circularContryButtonsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circularContryButtonsView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            circularContryButtonsView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            circularContryButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularContryButtonsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func configureGesture() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(rotateAction(with:))
        )
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func rotateAction(with gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if abs(translation.y) > 10 {
            circularContryButtonsView.rotate(
                to: (translation.y > 0 ? .up : .down)
            )
            
            gesture.setTranslation(.zero, in: view)
        }
    }
}
