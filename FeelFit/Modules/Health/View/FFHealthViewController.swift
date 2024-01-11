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
    
    func getStepsCount(_ indexPath: IndexPath,completion: @escaping (([StepCount]) -> Void)){
        var stepCounts = [StepCount]()
        let steps = HKQuantityType.quantityType(forIdentifier: .stepCount)! //Force unwrap
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        let withStartDate =  calendar.date(byAdding: .day, value: -6, to: startOfDay)! //Force unwrap
        let interval = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: withStartDate, end: now, options: .strictEndDate)
        let query = HKStatisticsCollectionQuery(quantityType: steps,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum,
                                                anchorDate: startOfDay,
                                                intervalComponents: interval)
        query.initialResultsHandler = { query, results, error in
            guard error == nil else {
                print("Error getting initial results with handler")
                return
            }
            guard let results = results else {
                print("Results equal nil. Error")
                return
            }
            results.enumerateStatistics(from: withStartDate, to: now) { stats, stop in
                if let steps = stats.sumQuantity()?.doubleValue(for: HKUnit.count()) {
                    let date = stats.startDate
                    stepCounts.append(StepCount(date: date, count: steps))
                }
            }
            stepCounts.reverse()
            completion(stepCounts)
        }
        healthStore.execute(query)
    }
    
    struct StepCount {
        let date: Date
        let count: Double
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
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
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value2, reuseIdentifier: "healthCell")
        getStepsCount(indexPath) { data in
            let value = data[indexPath.row]
            let stepsString = String(describing: value.count)
            let dateString = DateFormatter.localizedString(from: value.date, dateStyle: .medium, timeStyle: .none)
            DispatchQueue.main.async {
                cell.textLabel?.text = "Steps: " + stepsString
                cell.detailTextLabel?.text = "Date: " + dateString
            }
            
        }
        cell.textLabel?.sizeToFit()
        cell.detailTextLabel?.contentMode = .right
        cell.detailTextLabel?.textAlignment = .right
        return cell
    }
}

extension FFHealthViewController: UITableViewDelegate {
    
}

extension FFHealthViewController {
    private func setupConstraints(){
        
        
        view.addSubview(healthRequestResultLabel)
        healthRequestResultLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalToSuperview().inset(10)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(healthRequestResultLabel.snp.bottom).offset(-10)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(5)
        }
    }
}
