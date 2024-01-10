//
//  FFHealthViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import HealthKit




class FFHealthViewController: UIViewController, SetupViewController {
    
    private let healthStore = HKHealthStore()
    
    private let readTypes = Set(FFHealthData.readDataTypes)
    private let shareTypes = Set(FFHealthData.shareDataTypes)
    
    private var hasRequestedHealthData: Bool = false
    
    private let healthRequestResultLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = .headerFont(size: 16)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupViewModel()
        setupTableView()
        getHealthAuthorizationRequestStatus()
        setupConstraints()
    }
    
    @objc private func didTapRequestAccessHealth(){
        var textStatus: String = ""
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) {[unowned self] success, error in
            if let error = error {
                textStatus = "Applications gets error by trying to get access to Health. \(error.localizedDescription)"
            } else {
                if success {
                    if self.hasRequestedHealthData {
                        textStatus = "You already gave full access to Health request"
                    } else {
                        
                        textStatus = "Health kit authorization complete successfully"
                        hasRequestedHealthData = true
                        DispatchQueue.main.async { [unowned self] in
                            viewAlertController(text: "Successfully get access for Health", startDuration: 0.5, timer: 3, controllerView: view)
                        }
                    }
                } else {
                    textStatus = "Health kit authorization did not complete successfully"
                }
            }
            
        }
        DispatchQueue.main.async {
            self.healthRequestResultLabel.text = textStatus
        }
    }
    
    private func getHealthAuthorizationRequestStatus(){
        if !HKHealthStore.isHealthDataAvailable()  {
            DispatchQueue.main.async {
                self.healthRequestResultLabel.text = "Something goes wrong"
            }
            return
        }
        var textStatus: String = ""
        healthStore.getRequestStatusForAuthorization(toShare: shareTypes, read: readTypes) { authStatus, error in
            switch authStatus {
            case .unknown:
                textStatus = "Unknowned error occurred. Try again later."
            case .unnecessary:
                self.hasRequestedHealthData = true
                textStatus = "The app has already requested for all data. "
            case .shouldRequest:
                self.hasRequestedHealthData = false
                textStatus = "The app does not requested for all specific data yet"
            @unknown default:
                break
            }
        }
        DispatchQueue.main.async {
            self.healthRequestResultLabel.text = textStatus
        }
        
    }
    
    func getHealthData(completion: @escaping ((String,Date,Date) -> Void)){
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)!
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))
        query.initialResultsHandler = { query, results, error in
            guard error == nil else {
                return
            }
            guard let results = results else {
                return
            }
            results.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
                if let quantity = stats.sumQuantity() {
                    let step = Int(quantity.doubleValue(for: .count()))
                    let stepString = String(describing: step)
                    completion(stepString, startDate, endDate)
                }
            }
        }
        healthStore.execute(query)
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "healthCell")
        
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.lightBackgroundColor
    }
    
    func setupNavigationController() {
        title = "Health"
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "", imageName: "heart", action: #selector(didTapRequestAccessHealth), menu: nil)
    }
    
    func setupViewModel() {
        
    }
}

extension FFHealthViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value2, reuseIdentifier: "healthCell")
        cell.textLabel?.text = ""
        return cell
    }
}

extension FFHealthViewController: UITableViewDelegate {
    
}

extension FFHealthViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        
        view.addSubview(healthRequestResultLabel)
        healthRequestResultLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalToSuperview().inset(10)
        }
    }
}
