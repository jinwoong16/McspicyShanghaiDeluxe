//
//  CircularCountrySelectViewController.swift
//  McspicyShanghaiDeluxe
//
//  Created by jinwoong Kim on 7/7/24.
//

import UIKit

protocol CountryReceivable: AnyObject {
    func receive(country: Country)
}

final class CircularCountrySelectViewController: UIViewController {
    // MARK: - Components
    private lazy var circularContryButtonsView = CircularCountryButtonsView(
        countries: countries,
        currentCountry: currentCountry,
        frame: view.bounds
    )
    
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
    
    private lazy var countrySearchView: CountrySearchView = {
        CountrySearchView(frame: view.bounds)
    }()
    
    private lazy var feedbackHandler: FeedbackHandler = {
        FeedbackHandler(targetView: view)
    }()
    
    private let countries: [Country]
    private var currentCountry: Country?
    private var searchedCountries: [Country] = []
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
        configureCountrySearchView()
    }
    
    private func searchCountries(with searchText: String) {
        searchedCountries = countries.filter { country in
            country.currency.code.lowercased().contains(searchText.lowercased())
        }
        countrySearchView.searchResultView.reloadData()
        countrySearchView.searchBar.hideUnderline(searchedCountries.isEmpty)
        countrySearchView.updateSearchResultViewHeight(
            by: searchedCountries.count,
            maxHeight: view.frame.height * 0.3,
            isFullRounded: searchedCountries.isEmpty
        )
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = IntensityVisualEffectView(effect: blurEffect, intensity: 1)
        blurEffectView.frame = self.view.bounds
        self.view.addSubview(blurEffectView)
    }
    
    private func configureUI() {
        view.backgroundColor = .clear
        
        view.addSubview(circularContryButtonsView)
        view.addSubview(closeButton)
        view.addSubview(selectButton)
        view.addSubview(countrySearchView)
        
        circularContryButtonsView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        countrySearchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circularContryButtonsView.widthAnchor.constraint(equalTo: view.widthAnchor),
            circularContryButtonsView.heightAnchor.constraint(equalTo: view.heightAnchor),
            circularContryButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circularContryButtonsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            selectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            selectButton.heightAnchor.constraint(equalToConstant: 50),
            
            countrySearchView.topAnchor.constraint(equalTo: view.topAnchor),
            countrySearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countrySearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countrySearchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        countrySearchView.searchBackgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func configureButtons() {
        selectButton
            .addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    self.delegate?.receive(country: self.circularContryButtonsView.selectedCountry)
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
    
    private func configureCountrySearchView() {
        countrySearchView.searchBar.delegate = self
        countrySearchView.searchResultView.dataSource = self
        countrySearchView.searchResultView.delegate = self
        countrySearchView.searchResultView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        countrySearchView.searchBar.addAction(
            UIAction { [weak self] action in
                guard let sender = action.sender as? SearchField,
                      let text = sender.text else {
                    return
                }
                self?.searchCountries(with: text)
            },
            for: .editingChanged
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
        countrySearchView.searchBar.resignFirstResponder()
    }
}

extension CircularCountrySelectViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        countrySearchView.updateSearchBarWidth(to: .expanded(300))
        countrySearchView.hideBackgroundView(false)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: .zero) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        countrySearchView.searchBar.hideUnderline(true)
        countrySearchView.updateSearchBarWidth(to: .initial)
        countrySearchView.hideBackgroundView(true)
        countrySearchView.searchBar.text = ""
        searchedCountries = []
        countrySearchView.updateSearchResultViewHeight()
    }
}

extension CircularCountrySelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = searchedCountries[indexPath.row].name
        configuration.textProperties.color = .white
        cell.contentConfiguration = configuration
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
}

extension CircularCountrySelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.receive(country: searchedCountries[indexPath.row])
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height * 0.3 / 6
    }
}
