//
//  FFHealthViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import HealthKit


struct StepModel {
    let date: Date
    let count: Double
}

class FFHealthViewController: UIViewController, SetupViewController {
    
    private let healthStore = HKHealthStore()
    private let readTypes = Set(FFHealthData.readDataTypes)
    private let shareTypes = Set(FFHealthData.shareDataTypes)
    private let userDefaults = UserDefaults.standard
    
    private var hasRequestedHealthData: Bool = false
    private var dataTypeIdentifier: String = UserDefaults.standard.string(forKey: "dataTypeIdentifier") ?? "HKQuantityTypeIdentifierStepCount"
    private var titleForTable: String = "Steps"
    
    private var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupViewModel()
        setupTableView()
        getHealthAuthorizationRequestStatus()
        setupConstraints()
        requestForAccessToHealth()
        print(HKQuantityTypeIdentifier.stepCount.rawValue)
    }
    
    //MARK: - Action methods
    @objc private func didTapChooseLoadingType(){
        
    }
    
    //
    private func didSelectDataTypeIdentifier(_ dataTypeIdentifier: String){
        userDefaults.setValue(dataTypeIdentifier, forKey: "dataTypeIdentifier")
        self.dataTypeIdentifier = dataTypeIdentifier
        
        FFHealthData.requestHealthDataAccessIfNeeded(dataTypes: [self.dataTypeIdentifier]) { [weak self] success, status in
            if success {
                
            } else {
                
            }
        }
    }
    
    private func requestForAccessToHealth(){
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
                        
                    }
                } else {
                    textStatus = "Health kit authorization did not complete successfully"
                }
            }
            
        }
        DispatchQueue.main.async { [unowned self] in
            viewAlertController(text: textStatus, startDuration: 0.5, timer: 3, controllerView: view)
        }
    }
    
    private func getHealthAuthorizationRequestStatus(){
        if !HKHealthStore.isHealthDataAvailable()  {
            DispatchQueue.main.async { [unowned self] in
                viewAlertController(text: "Health Data is unavailable. Try again later", startDuration: 0.5, timer: 3, controllerView: view)
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
                textStatus = " Unnecessary .You have already allow all data for using "
            case .shouldRequest:
                self.hasRequestedHealthData = false
                textStatus = "Should request .The app does not requested for all specific data yet"
            @unknown default:
                break
            }
        }
        DispatchQueue.main.async { [unowned self] in
            viewAlertController(text: textStatus, startDuration: 0.5, timer: 3, controllerView: view)
        }
        
    }
    
    func getStepsCount(_ indexPath: IndexPath,completion: @escaping (([StepModel]) -> Void)){
        var stepCounts = [StepModel]()
        let steps = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)! //Force unwrap
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
            guard error == nil,
                  let results = results else {
                let title = "Error getting initial results with handler"
                self.alertError(title: title)
                return
            }
            results.enumerateStatistics(from: withStartDate, to: now) { stats, stop in
                if let steps = stats.sumQuantity()?.doubleValue(for: HKUnit.count()) {
                    let date = stats.startDate
                    stepCounts.append(StepModel(date: date, count: steps))
                } else if let meters = stats.sumQuantity()?.doubleValue(for: .meter()) {
                    let date = stats.startDate
                    stepCounts.append(StepModel(date: date, count: meters))
                }
                
            }
            stepCounts.reverse()
            completion(stepCounts)
        }
        healthStore.execute(query)
    }
    
    
    //MARK: Setup methods
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(FFHealthTableViewCell.self, forCellReuseIdentifier: FFHealthTableViewCell.identifier)
        tableView.bounces = false
        tableView.allowsSelection = false
        
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.lightBackgroundColor
    }
    
    func setupNavigationController() {
        title = "Health"
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "", imageName: "line.3.horizontal.decrease.circle", action: #selector(didTapChooseLoadingType), menu: nil)
    }
    
    func setupViewModel() {
        
    }
}

extension FFHealthViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  FFHealthTableViewCell.identifier, for: indexPath) as! FFHealthTableViewCell
        getStepsCount(indexPath) { data in
            cell.configureCell(indexPath, data)
        }
        return cell
    }
}

extension FFHealthViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension FFHealthViewController {
    private func setupConstraints(){
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-10)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(5)
        }
    }
}
