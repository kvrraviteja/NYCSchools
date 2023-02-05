//
//  SchoolDetailsViewController.swift
//  NYC Schools
//
//  Created by Ravi Theja Karnatakam on 2/4/23.
//

import Foundation
import UIKit

class SchoolDetailsViewController: UIViewController {
    let detailsViewModel = NYCSchoolDetailsViewModel()
    
    // MARK: - Lazy variables
    
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
    
    lazy var schoolNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Charter-Bold", size: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()

    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        stack.distribution = .equalSpacing
        return stack
    }()
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("SAT Scores", comment: "")
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
    }
    
    func setUp(_ school: School) {
        prepareData(school)
    }
    
    //MARK: - Prepare Data
    
    func prepareData(_ school: School) {
        // Create an async task to fetch school details,
        // and take appropriate action when fetch completes.
        Task {
            // Optionally, show a loading indicator while data is loading.
            showMessage("Loading SAT info for \(school.name)")
            setUpSchoolName(school)

            // Fetch school SAT data.
            await detailsViewModel.fetchDetails(school)
                        
            // Act on the school data fetched.
            switch detailsViewModel.dataLoadingState {
            case .loaded:
                // Display data
                if let score = detailsViewModel.scores.first {
                    setUpInterface(score)
                }
                
            case .failedToLoad:
                // Provide retry option here.
                showMessage("Failed to load SAT scores.")
            case .noDataFound:
                showMessage("No data found. Try again later.")
            default:
                print("Do nothing")
            }
        }
    }
    
    //MARK: - Interface
    
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
        
        infoLabel.isHidden = false
        infoLabel.text = message
    }

    
    func titleLabel(_ text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Charter-Bold", size: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.text = text
        return label
    }

    func scoreLabel(_ text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica-Regular", size: 18)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.text = text
        return label
    }
    
    func setUpSchoolName(_ school: School) {
        view.addSubview(schoolNameLabel)
        schoolNameLabel.text = school.name

        NSLayoutConstraint.activate([
            schoolNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 10),
            schoolNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            schoolNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }

    /**
     Builds interface required to display SAT scores. Since the number of data points displayed is static, a stack view is chosen over scrollable views.
     */
    func setUpInterface(_ score: SATScore) {
        infoLabel.isHidden = true
        
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel("Number of students appeared for SAT:"))
        stackView.addArrangedSubview(scoreLabel(score.studentsCount))
        
        stackView.addArrangedSubview(titleLabel("Critical reading average score:"))
        stackView.addArrangedSubview(scoreLabel(score.readingScore))

        stackView.addArrangedSubview(titleLabel("Math average score:"))
        stackView.addArrangedSubview(scoreLabel(score.mathScore))

        stackView.addArrangedSubview(titleLabel("Writing average score:"))
        stackView.addArrangedSubview(scoreLabel(score.writingScore))
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: schoolNameLabel.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        view.layoutIfNeeded()
    }
}
