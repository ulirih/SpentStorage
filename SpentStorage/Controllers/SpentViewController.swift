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
        view.addSubview(datePicker)
        view.addSubview(saveButton)
        
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
            
            datePicker.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 32),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 32),
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
        let selectedRow = tableView.indexPathForSelectedRow
        if selectedRow == nil || (priceTextField.text?.isEmpty ?? true) || Float(priceTextField.text!) == nil {
            return
        }
        
        viewPresenter.addSpent(price: Float(priceTextField.text!)!, date: datePicker.date, type: categories[selectedRow!.row])
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
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
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
        cell.contentConfiguration = cellConfig
        
        return cell
    }
}
