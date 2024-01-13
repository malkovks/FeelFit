//
//  FFHealthViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import HealthKit


struct HealthModelValue {
    let date: Date
    let value: Double
}

class FFHealthViewController: UIViewController, SetupViewController {
    
    private let healthStore = HKHealthStore()
    private let readTypes = Set(FFHealthData.readDataTypes)
    private let shareTypes = Set(FFHealthData.shareDataTypes)
    private let userDefaults = UserDefaults.standard
    
    private var hasRequestedHealthData: Bool = false
    private var dataTypeIdentifier: String = UserDefaults.standard.string(forKey: "dataTypeIdentifier") ?? "HKQuantityTypeIdentifierStepCount"
    private var titleForTable: String {
        return getDataTypeName(HKQuantityTypeIdentifier(rawValue: dataTypeIdentifier))
    }
    private var healthModel: [HealthModelValue] = [HealthModelValue]()
    
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
    }
    
    //MARK: - Action methods
    @objc private func didTapChooseLoadingType(){
        let title = "Select displaying data type"
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for type in FFHealthData.allTypeQuantityTypeIdentifiers {
            let actionTitle = getDataTypeName(type)
            let action = UIAlertAction(title: actionTitle, style: .default) { [weak self] _ in
                self?.selectDataTypeIdentifier(type)
            }
            alertController.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    //
    private func selectDataTypeIdentifier(_ dataTypeIdentifier: HKQuantityTypeIdentifier){
        userDefaults.setValue(dataTypeIdentifier.rawValue, forKey: "dataTypeIdentifier")
        self.dataTypeIdentifier = dataTypeIdentifier.rawValue
        let index = [
            IndexPath(row: 0, section: 0),
            IndexPath(row: 1, section: 0),
            IndexPath(row: 2, section: 0),
            IndexPath(row: 3, section: 0),
            IndexPath(row: 4, section: 0),
            IndexPath(row: 5, section: 0),
            IndexPath(row: 6, section: 0)
        ]
        
        self.tableView.reloadRows(at: index, with: .fade)
        self.tableView.reloadData()
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
    
    func uploadSelectedData(id: String = "HKQuantityTypeIdentifierStepCount",data  completion: @escaping (([HealthModelValue]) -> Void)){
        var value: [HealthModelValue] = [HealthModelValue]()
        let identifier = HKQuantityTypeIdentifier(rawValue: id)
        guard let steps = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
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
        query.initialResultsHandler = { [weak self] query, results, error in
            guard error == nil,
                  let results = results else {
                let title = "Error getting initial results with handler"
                self?.alertError(title: title)
                return
            }
            results.enumerateStatistics(from: withStartDate, to: now) {  stats, stop in
                let startDate = stats.startDate
                switch identifier {
                case .stepCount:
                    guard let steps = stats.sumQuantity()?.doubleValue(for: HKUnit.count()) else { return }
                    let date = stats.startDate
                    value.append(HealthModelValue.init(date: startDate, value: steps))
                case .distanceWalkingRunning:
                    guard let meters = stats.sumQuantity()?.doubleValue(for: HKUnit.meter()) else { return }
                    value.append(HealthModelValue.init(date: startDate, value: meters))
                case .activeEnergyBurned:
                    guard let calories = stats.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) else { return }
                    value.append(HealthModelValue(date: startDate, value: calories))
                default: break
                }
                
            }
            value.reverse()
            completion(value)
            
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
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  FFHealthTableViewCell.identifier, for: indexPath) as! FFHealthTableViewCell
        let type = dataTypeIdentifier
        uploadSelectedData(id: dataTypeIdentifier) { [unowned self] model in
            cell.configureCell(indexPath, self.dataTypeIdentifier, model)
        }
        return cell
    }
    
    
}

extension FFHealthViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.width, height: 40))
        label.font = UIFont.headerFont(size: 24)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = FFResources.Colors.detailTextColor
        label.text = titleForTable
        return label
    }
}

extension FFHealthViewController {
    private func setupConstraints(){
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(5)
        }
    }
}
