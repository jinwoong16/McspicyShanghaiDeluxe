//
//  LandingViewController.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/11/24.
//

import UIKit
import Combine

// wii be ignored
final class LandingViewController: UIViewController {
    private lazy var helloLabel: UILabel = {
        let helloLabel = UILabel()
        helloLabel.text = """
        완벽하게 이해했어! (이해못함)
        
        오.... (오 아님)
        """
        helloLabel.numberOfLines = 0
        helloLabel.textColor = .white
        helloLabel.font = .systemFont(ofSize: 26)
        
        return helloLabel
    }()
    
    private lazy var countryLabel: UILabel = {
        let countryLabel = UILabel()
        countryLabel.text = "지금은 아무것도 선택되지 않았어요."
        countryLabel.textColor = .white
        
        return countryLabel
    }()

    private lazy var selectButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Select Country"
        configuration.baseBackgroundColor = .addButton
        
        return UIButton(configuration: configuration)
    }()
    
    private let bigmacCalculator: any BigmacCalculatable
    
    //
    private var currentCountry: Country?
    private var anyCancellables = Set<AnyCancellable>()
    // 신기해 ~
    
    init(bigmacCalculator: any BigmacCalculatable) {
        self.bigmacCalculator = bigmacCalculator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureButton()
        view.isHidden = true
        
        waitUntilReady()
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(helloLabel)
        view.addSubview(countryLabel)
        view.addSubview(selectButton)
        
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            helloLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            countryLabel.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 50),
            countryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ])
    }
    
    private func configureButton() {
        selectButton
            .addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    
                    let circularCountrySelectViewController = CircularCountrySelectViewController(
                        countries: self.bigmacCalculator.getAvailableCountries(),
                        currentCountry: currentCountry
                    )
                    circularCountrySelectViewController.modalPresentationStyle = .overFullScreen
                    circularCountrySelectViewController.modalTransitionStyle = .crossDissolve
                    circularCountrySelectViewController.delegate = self
                    self.present(circularCountrySelectViewController, animated: true)
                },
                for: .touchUpInside
            )
    }
    
    private func waitUntilReady() {
        bigmacCalculator
            .readyToUpdateUI()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("Ready...")
                self?.view.isHidden = false
            }
            .store(in: &anyCancellables)
    }
}

extension LandingViewController: CountryReceivable {
    func receive(country: Country) {
        countryLabel.text = "\(country.flag) \(country.name)"
        currentCountry = country
    }
}
