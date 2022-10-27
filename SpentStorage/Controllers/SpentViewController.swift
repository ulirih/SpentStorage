//
//  SpentViewController.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 27.10.2022.
//

import UIKit

class SpentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupLayout()
        setupConstrains()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupLayout() {
        view.addSubview(priceTextField)
        view.addSubview(datePicker)
        view.addSubview(saveButton)
        view.addSubview(tableView)
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
        // TODO: refactor to single resource
        view.backgroundColor = UIColor().fromHexColor(hex: "#F8F9F9")
    }
    
    @objc
    private func onCloseController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func onPressSave() {
        print("add save to db")
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
        picker.date = Date.now
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        
        return picker
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor().fromHexColor(hex: "#437BFE"), for: .normal)
        button.setTitleColor(UIColor().fromHexColor(hex: "#437BFE", alpha: 0.5), for: .highlighted)
        button.addTarget(self, action: #selector(onPressSave), for: .touchUpInside)
     
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()

}


// MARK: TableView Delegates
extension SpentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
