//
//  SchoolsViewController.swift
//  NYC Schools
//
//  Created by Ravi Theja Karnatakam on 2/1/23.
//

import UIKit

class SchoolsViewController: UIViewController {
    let schoolsViewModel = NYCSchoolsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("NYC Schools", comment: "")
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        
        prepareSchoolsData()
    }
    
    // MARK: - Lazy loading
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.separatorStyle = .none
        tableView.register(SchoolsTableViewCell.self,
                           forCellReuseIdentifier: String(describing: SchoolsTableViewCell.self))
        tableView.register(SchoolHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: SchoolHeaderView.self))
        return tableView
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Charter-Bold", size: 24)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Prepare Data

    func prepareSchoolsData() {
        // Create an async task to fetch schools data,
        // and takes appropriate action when fetch completes.
        Task {
            // Optionally, show a loading indicator while data is loading.
            showMessage("Loading schools...")

            // Fetch schools.
            await schoolsViewModel.fetchSchools()
                        
            // Act on the school data fetched.
            switch schoolsViewModel.dataLoadingState {
            case .loaded:
                setUpSchoolsTableView()
            case .failedToLoad:
                // Provide retry option here.
                showMessage("Failed to load schools data.")
            case .noDataFound:
                showMessage("No data found.")
            default:
                print("Do nothing")
            }
        }
    }
    
    //MARK: - Interface

    private func setUpSchoolsTableView() {
        infoLabel.isHidden = true

        if (tableView.superview == nil) {
            view.addSubview(tableView)

            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaInsets.bottom)
            ])
        }
        
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    private func setUpInfoLabel() {
        view.addSubview(infoLabel)

        NSLayoutConstraint.activate([
            infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func showMessage(_ message: String) {
        if (infoLabel.superview == nil) {
            setUpInfoLabel()
        }
        
        tableView.isHidden = true
        infoLabel.isHidden = false
        infoLabel.text = message
    }
}

/**
 Schools table view's delegate and data source. Displays all available schools grouped by city.
 A cool feature would be to search school by city / name / zip etc.,
 */
extension SchoolsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: SchoolHeaderView.self)) as? SchoolHeaderView else { return nil }
        
        headerView.setUp(schoolsViewModel.allCities()[section])
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return schoolsViewModel.numberOfCities()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolsViewModel.numberOfSchoolsInCity(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let school: NYCSchool = schoolsViewModel.school(indexPath.row, cityIndex: indexPath.section),
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SchoolsTableViewCell.self), for: indexPath) as? SchoolsTableViewCell else { return UITableViewCell() }
        
        cell.setUp(school)
        // Current visual treatment looked better with out disclosure indicator.
        // So, commneting out.
//        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let school: NYCSchool = schoolsViewModel.school(indexPath.row, cityIndex: indexPath.section) {
            // navigate to details view
            let schoolDataViewController = SchoolDetailsViewController()
            navigationController?.pushViewController(schoolDataViewController, animated: true)
            schoolDataViewController.setUp(school)
        }
    }
}
