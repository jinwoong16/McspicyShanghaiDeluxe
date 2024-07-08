import UIKit

struct SelectedCountry: Codable {
    var countryName: String
    let count: Int
}

class IndexViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISceneDelegate {
    
    // MARK: - Properties
    var selectedCountry: [SelectedCountry] = [] {
        didSet {
            print("country \(selectedCountry)")
            tableView.reloadData()
            tableView.backgroundView?.isHidden = !selectedCountry.isEmpty
        }
    }
    
    let countries: [(flag: String, name: String)] = [
        ("🇳🇴", "노르웨이"),
        ("🇲🇾", "말레이시아"),
        ("🇺🇸", "미국"),
        ("🇸🇪", "스웨덴"),
        ("🇨🇭", "스위스"),
        ("🇬🇧", "영국"),
        ("🇮🇩", "인도네시아"),
        ("🇯🇵", "일본"),
        ("🇨🇳", "중국"),
        ("🇨🇦", "캐나다"),
        ("🇭🇰", "홍콩"),
        ("🇹🇭", "태국"),
        ("🇦🇺", "호주"),
        ("🇳🇿", "뉴질랜드"),
        ("🇸🇬", "싱가포르")
    ]
    
    let bigMacPricesInUSD: [String: Double] = [
        "노르웨이": 6.23,
        "말레이시아": 2.34,
        "미국": 5.69,
        "스웨덴": 6.15,
        "스위스": 6.71,
        "영국": 4.50,
        "인도네시아": 2.36,
        "일본": 3.50,
        "중국": 3.37,
        "캐나다": 6.77,
        "홍콩": 2.81,
        "태국": 4.40,
        "호주": 5.73,
        "뉴질랜드": 5.33,
        "싱가포르": 5.18
    ]
    
    //koreaLabel이었던 곳입니다! 버튼으로 변경하신 후 baseCurrencyCountryButton 로 해주시면 됩니다 :)
    private let baseCurrencyCountryLabel: UILabel = {
        let label = UILabel()
        label.text = "🇰🇷 대한민국"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let baseCurrencyTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.placeholder = "0"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 36)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "0", attributes: placeholderAttributes)
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 36)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        return textField
    }()
    
    private let baseCurrencySuffixLabel: UILabel = {
        let label = UILabel()
        label.text = "원"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let conversionLabel: UILabel = {
        let label = UILabel()
        label.text = "으로"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tableView: UITableView = UITableView()
    //    private let purchaseLabel: UILabel = UILabel()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "232123")
        autoLayout()
        setupEmptyView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        
        setupAddButton()
        let loadedCountries = loadCountries()
        self.selectedCountry = loadedCountries
        tableView.backgroundView?.isHidden = !selectedCountry.isEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Functions
    private func setupEmptyView() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor(hex: "2C292C")
        containerView.layer.cornerRadius = 15
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "나라를 선택해 주세요."
        label.textColor = UIColor(hex: "999999")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(label)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: baseCurrencySuffixLabel.bottomAnchor, constant: 50),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 340),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func autoLayout() {
        view.addSubview(baseCurrencyCountryLabel)
        view.addSubview(baseCurrencyTextField)
        view.addSubview(baseCurrencySuffixLabel)
        view.addSubview(conversionLabel)
        
        NSLayoutConstraint.activate([
            baseCurrencyCountryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            baseCurrencyCountryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            baseCurrencyTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            baseCurrencyTextField.trailingAnchor.constraint(equalTo: baseCurrencySuffixLabel.leadingAnchor, constant: -8),
            baseCurrencyTextField.topAnchor.constraint(equalTo: baseCurrencyCountryLabel.bottomAnchor, constant: 16),
            
            baseCurrencySuffixLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            baseCurrencySuffixLabel.topAnchor.constraint(equalTo: baseCurrencyCountryLabel.bottomAnchor, constant: 16),
            
            conversionLabel.trailingAnchor.constraint(equalTo: baseCurrencySuffixLabel.trailingAnchor),
            conversionLabel.topAnchor.constraint(equalTo: baseCurrencySuffixLabel.bottomAnchor, constant: 4)
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(hex: "232123")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: conversionLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupAddButton() {
        let addButton = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let plusImage = UIImage(systemName: "plus.circle", withConfiguration: configuration)
        addButton.setImage(plusImage, for: .normal)
        addButton.tintColor = .white
        //        addButton.addTarget(self, action: #selector(showCountryPicker), for: .touchUpInside)
        view.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func saveCountries(countries: [SelectedCountry]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(countries) {
            UserDefaults.standard.set(encoded, forKey: "SelectedCountries")
        }
    }
    
    func loadCountries() -> [SelectedCountry] {
        if let savedCountries = UserDefaults.standard.object(forKey: "SelectedCountries") as? Data {
            let decoder = JSONDecoder()
            if let loadedCountries = try? decoder.decode([SelectedCountry].self, from: savedCountries) {
                return loadedCountries
            }
        }
        return []
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCountry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let country = selectedCountry[indexPath.row]
        cell.textLabel?.text = "\(country.countryName): \(country.count) 개"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(hex: "232123")
        return cell
    }
}

#Preview {
    return UINavigationController(rootViewController: IndexViewController())
}
