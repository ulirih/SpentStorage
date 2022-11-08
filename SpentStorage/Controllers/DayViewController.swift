//
//  ViewController.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 26.10.2022.
//

import UIKit

class DayViewController: UIViewController {
    
    private let presenter = DayViewPresenter(service: SpentService())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupLayout()
        setupConstrains()
        
        presenter.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.fetch(on: Date())
    }
    
    private func setupNavBar() {
        view.backgroundColor = Colors.backgroundColor
        title = Tabs.day.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onPressNavRightItem)
        )
    }
    
    private func setupLayout() {
        headerView.addSubview(sumLabel)
        headerView.addSubview(previousDateButton)
        headerView.addSubview(nextDateButton)
        headerView.addSubview(dateLabel)
        
        view.addSubview(headerView)
        view.addSubview(tableView)
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sumLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            sumLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            dateLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: sumLabel.bottomAnchor, constant: 16),
            
            previousDateButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            previousDateButton.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            previousDateButton.heightAnchor.constraint(equalToConstant: 40),
            previousDateButton.widthAnchor.constraint(equalToConstant: 40),
            
            nextDateButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            nextDateButton.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            nextDateButton.heightAnchor.constraint(equalToConstant: 40),
            nextDateButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: Views
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private let sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.getHelveticFont(size: 32)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = UIFont.getHelveticFont()
        date.textColor = Colors.navigationBarTitleColor
        
        return date
    }()
    
    private let previousDateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(didPressPreviousButton), for: .touchUpInside)
        
        return button
    }()
    
    private let nextDateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.addTarget(self, action: #selector(didPressNextButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc
    private func onPressNavRightItem() {
        let spentVC = SpentViewController()
        
        let nav = NavigationController(rootViewController: spentVC)
        nav.modalPresentationStyle = .pageSheet
        
        present(nav, animated: true, completion: nil)
    }
    
    @objc
    private func didPressPreviousButton() {
        presenter.onDayStepFetch(step: .previousDay)
    }
    
    @objc
    private func didPressNextButton() {
        presenter.onDayStepFetch(step: .nextDay)
    }
}

// MARK: Presenter Delegate
extension DayViewController: DayViewPresenterDelegate {
    
    func presentSpents(data: [SpentModel]) {
        print(data)
    }
    
    func presentSum(sum: Float) {
        sumLabel.text = sum.toFormattedString()
    }
    
    func presentDate(date: Date) {
        let isToday = Calendar.current.isDateInToday(date)
        
        UIView.animate(withDuration: 0.3) {
            self.nextDateButton.alpha = isToday ? 0 : 1
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        dateLabel.text = formatter.string(from: date)
    }
    
    func showError(errorMessage: String) {
        showAlertError(message: errorMessage)
    }
}
