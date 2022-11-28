//
//  SpentViewController.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 27.10.2022.
//

import UIKit

class SpentViewController: UIViewController {
    
    var didDissmisController: (() -> Void)?
    
    private let viewPresenter: SpentViewPresenter = SpentViewPresenter(service: SpentService())
    private var categories: [CategoryModel] = []
    private let reuseIdentifier = "CategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupLayout()
        setupConstrains()
        
        viewPresenter.delegate = self
        viewPresenter.fetchCategories()
    }
    
    private func setupLayout() {
        view.addSubview(priceTextField)
        view.addSubview(saveButton)
        
        datePickerContainer.addArrangedSubview(datePicker)
        view.addSubview(datePickerContainer)

        view.addSubview(tableView)
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            priceTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            priceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            datePickerContainer.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 16),
            datePickerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            datePickerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePickerContainer.heightAnchor.constraint(equalToConstant: 34),
            
            tableView.topAnchor.constraint(equalTo: datePickerContainer.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupNavBar() {
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(onCloseController)
        )
        self.navigationItem.rightBarButtonItem = doneButton
        
        title = "Add"
    }
    
    @objc
    private func onCloseController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func onPressSave() {
        let selectedRow = tableView.indexPathForSelectedRow?.row
        if selectedRow == nil || (priceTextField.text?.isEmpty ?? true) || Float(priceTextField.text!) == nil {
            showAlertError(message: "Category of spend is not selected")
            return
        }
        
        viewPresenter.addSpent(
            price: Float(priceTextField.text!)!,
            date: datePicker.date,
            type: categories[selectedRow!]
        )
    }
    
    // MARK: views
    private let priceTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Price"
        field.isEnabled = true
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.keyboardType = .decimalPad
        
        return field
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.date = Date()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        
        return picker
    }()
    
    private let datePickerContainer: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.distribution = .fill
        
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.getNunitoFont(type: .regular)
        label.textColor = Colors.navigationBarTitleColor
        container.addArrangedSubview(label)
        
        return container
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.getNunitoFont(type: .bold, size: 18)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = Colors.buttonBackgroundColor
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(onPressSave), for: .touchUpInside)
     
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()

}


// MARK: Presenter Delegate
extension SpentViewController: SpentViewPresenterDelegate {
    func presentCategories(categories: [CategoryModel]) {
        self.categories = categories
        tableView.reloadData()
    }
    
    func onSpentSaved() {
        dismiss(animated: true) { [weak self] in
            self?.didDissmisController?()
        }
    }
    
    func showError(errorMessage: String) {
        showAlertError(message: errorMessage)
    }
}


// MARK: TableView Delegates
extension SpentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        var cellConfig = cell.defaultContentConfiguration()
        cellConfig.text = categories[indexPath.row].name
        cellConfig.textProperties.font = UIFont.getNunitoFont(type: .regular)
        cell.contentConfiguration = cellConfig
        
        return cell
    }
}
