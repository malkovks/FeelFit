//
//  FFHealthViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import HealthKit
import BackgroundTasks
import UserNotifications
import CareKit
import AVFoundation


struct HealthModelValue {
    let date: Date
    let value: Double
    let unit: HKUnit
    ///Identifier for HealthKit item like HKQuantityTypeIdentifier or HKObjectType string type
    let identifier: String
}

enum HealthModelDate: String {
    case week = "week"
    case month = "month"
    case sixMonth = "sixMonth"
    case year = "year"
}

class FFHealthViewController: UIViewController, SetupViewController {
    
    
    private var viewModel: FFHealthViewModel!
    private let healthStore = HKHealthStore()
    private let careKitStore = OCKStore(name: "UserDataStore",type: .inMemory)
    private let readTypes = Set(FFHealthData.readDataTypes)
    private let shareTypes = Set(FFHealthData.shareDataTypes)
    private let userDefaults = UserDefaults.standard
    private let calendar = Calendar.current
    
    private var fixedIndexPath: [IndexPath] {
        return [
            IndexPath(row: 0, section: 0),
            IndexPath(row: 1, section: 0),
            IndexPath(row: 2, section: 0),
            IndexPath(row: 3, section: 0),
            IndexPath(row: 4, section: 0),
            IndexPath(row: 5, section: 0),
            IndexPath(row: 6, section: 0)
        ]
    }
    
    //MARK: - Background task
    private var backgroundTaskId: UIBackgroundTaskIdentifier = .invalid
    private var timer: Timer?
    ///Health kit observer
    private var observerQuery: HKObserverQuery?
    
    private var isHealthKitAccess: Bool = UserDefaults.standard.bool(forKey: "healthKitAccess")
    private var dataTypeIdentifier: String = UserDefaults.standard.string(forKey: "dataTypeIdentifier") ?? "HKQuantityTypeIdentifierStepCount"
    private var titleForTable: String {
        return getDataTypeName(HKQuantityTypeIdentifier(rawValue: dataTypeIdentifier))
    }
    private var healthModel: [HealthModelValue] = [HealthModelValue]()
    
    private var tableView: UITableView!
    private let scrollView: UIScrollView = UIScrollView(frame: .zero)
    private let chartView = OCKCartesianChartView(type: .bar)
    private let activityChartView = OCKCartesianChartView(type: .bar)
    private let refreshControl = UIRefreshControl()
    private var segmentController: UISegmentedControl!
    
    private let openProfileButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        button.layer.cornerRadius = button.frame.size.width/2
        button.layer.masksToBounds = true
        button.backgroundColor = FFResources.Colors.backgroundColor
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.tintColor = FFResources.Colors.activeColor
        return button
    }()
    
    private let setupChartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = FFResources.Colors.activeColor
        button.layer.cornerRadius = button.frame.size.width / 2
        button.layer.masksToBounds = true
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupSegmentController()
        setupConstraints()
        setupChartView()
        setupScrollView()
        setupRefreshControl()
        setupActivityChartView()
       
        
        if isHealthKitAccess {
            setupBackgroundTask()
            requestAccessToBackgroundMode()
        } else {
            FFHealthDataAccess.shared.requestForAccessToHealth()
        }
    }
    
    
    

    //MARK: - Target Methods
    @objc private func didTapOpenProfile(_ sender: UIButton){
        let vc = FFHealthUserProfileViewController()
        let navVC = FFNavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .automatic
        navVC.isNavigationBarHidden = false
        present(navVC, animated: true)
    }
    
    ///Method for UIRefreshControl for updating data and reload view
    @objc private func didTapRefreshView(){
        setupChartView()
        setupView()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadRows(at: self!.fixedIndexPath, with: .fade)
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
                self?.refreshControl.endRefreshing()
            }
        }
    }
    ///Method for selecting data type identifier for uploading it and display to table view and chart view
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
    
    @objc private func didTapOpenChart(){
        let config = OCKDataSeriesConfiguration(taskID: "", legendTitle: "Some title", gradientStartColor: .systemOrange, gradientEndColor: .systemRed, markerSize: 1, eventAggregator: .countOutcomes)
        
        let manager = OCKSynchronizedStoreManager(wrapping: careKitStore)
        let barChart = FFHealthCartesianChartViewController(plotType: .bar, selectedDate: Date(), configurations: [config], storeManager: manager)
        present(barChart, animated: true)
    }
    
    func setupSegmentController(){
        let items = ["WK" ,"MTH", "6 MTH", "YEAR"]
        segmentController = UISegmentedControl(items: items)
        segmentController.selectedSegmentIndex = 0
        segmentController.tintColor = FFResources.Colors.activeColor
        segmentController.backgroundColor = .systemRed
        segmentController.layer.cornerRadius = 12
        segmentController.layer.masksToBounds = true
        segmentController.addTarget(self, action: #selector(changeSegmentValue), for: .valueChanged)
    }
    
    @objc private func changeSegmentValue(_ sender: UISegmentedControl){
        
    }
    
    func setupChartView(){
        chartView.headerView.titleLabel.text = titleForTable
        chartView.headerView.detailLabel.text = createChartWeeklyDateRangeLabel(startDate: nil) //Добавление в детейл лейблам даты
        
        chartView.applyConfiguration()
        chartView.graphView.horizontalAxisMarkers = FeelFit.createHorizontalAxisMarkers()
        uploadSelectedData { [weak self] value in
            let stepValues: [CGFloat] = value.map { CGFloat($0.value) }
            DispatchQueue.main.async {
                let series = OCKDataSeries(values: stepValues, title: self?.titleForTable ?? "Default" , color: FFResources.Colors.activeColor)
                self?.chartView.graphView.dataSeries = [series]
            }
        }
    }
    
    
    
    private func setupActivityChartView(){
        activityChartView.contentStackView.distribution = .fillProportionally
        activityChartView.headerView.titleLabel.text = "Activity"
        
        
        activityChartView.applyConfiguration()
        let (startDate, _) = dateRangeConfiguration(type: .year)
        
        activityChartView.headerView.detailLabel.text = createChartWeeklyDateRangeLabel(startDate: startDate)
        //сделать axisMarkersTitle
        let caloriesId = HKQuantityTypeIdentifier.activeEnergyBurned.rawValue
    
        uploadSelectedData(id: caloriesId,dateType: .year) { model in
            let value: [CGFloat] = model.map { CGFloat($0.value) }
            let series = OCKDataSeries(values: value, title: "Calories", gradientStartColor: .systemYellow, gradientEndColor: .systemRed, size: 5)
            DispatchQueue.main.async {
                self.activityChartView.graphView.dataSeries.append(series)
            }
        }
    }
    
    
    //MARK: - UIApplication background task
    func setupBackgroundTask(){
        UIApplication.shared.isIdleTimerDisabled = true
        backgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: "Malkov.KS.FeelFit.fitness.health_data_refresh", expirationHandler: { [weak self] in
            self?.stopBackgroundTaskRequest()
        })
        //repeat check value every 10 minutes in background
        timer = Timer.scheduledTimer(withTimeInterval: 60*15, repeats: true, block: { [weak self] _ in
            DispatchQueue.global(qos: .background).async {
                self?.setupObserverQuery()
            }
        })
    }
    
    func stopBackgroundTaskRequest(){
        stopCountingSteps()
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
            UIApplication.shared.endBackgroundTask(self.backgroundTaskId)
            self.backgroundTaskId = .invalid
        }
    }
    
    func stopCountingSteps(){
        if let observerQuery = observerQuery {
            healthStore.stop(observerQuery)
            print("health observer is cancelled")
        }
    }
    
    func shouldSendNotification() -> Bool {
        let lastNotification = userDefaults.object(forKey: "lastNotification") as? Date ?? Date()
        let currentDate = Date()
        let components = calendar.dateComponents([.day], from: lastNotification, to: currentDate)
        if let days = components.day, days >= 1 {
            userDefaults.set(currentDate, forKey: "lastNotification")
            userDefaults.set(false, forKey: "sendStatusNotification")
            return true
        } else {
            return userDefaults.bool(forKey: "sendStatusNotification")
        }
    }
    
    //функция запроса разрешения на работе в фоновом режиме и отслеживание данных
    func requestAccessToBackgroundMode() {
        if !HKHealthStore.isHealthDataAvailable() {
            alertError()
            return
        }
        
        guard let steps = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        healthStore.enableBackgroundDelivery(for: steps, frequency: .immediate) { status, error in
            if status {
                print("Background delivery is enabled")
            } else if let error = error {
                print("Error with background access ---\n" + error.localizedDescription)
            }
        }
    }
    //функция для создания предиката для запроса данных за последний день и создание наблюдателя для получения обновлений
    func setupObserverQuery(){
        let now = Date()
        let startOfDay = calendar.startOfDay(for: .now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        observerQuery = HKObserverQuery(sampleType: stepCountType, predicate: predicate, updateHandler: { query, completionHandler, error in
            guard error == nil else {
                print(String(describing:error?.localizedDescription))
                return
            }
            self.handleStepCountUpdate()
            completionHandler()
        })
        healthStore.execute(observerQuery!)
    }
    
    //функция которая будет вызываться каждый раз при получении оьновления о количестве шагов
    func handleStepCountUpdate(){
        if isHealthKitAccess {
            guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
            let now = Date()
            let startOfDay = calendar.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
            
            let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate) { [unowned self] query, stats, error in
                guard error == nil,
                      let result = stats,
                      let stepCount = result.sumQuantity()?.doubleValue(for: HKUnit.count())
                else {
                    self.stopBackgroundTaskRequest()
                    print(String(describing:error?.localizedDescription))
                    return
                }
                let value = userDefaults.bool(forKey: "sendStatusNotification")
                if stepCount >= 10_000 && !value {
                    self.sendLocalNotification()
                    self.userDefaults.set(true, forKey: "sendStatusNotification")
                } else {
                    print("Steps count is \(stepCount)")
                    self.userDefaults.set(false, forKey: "sendStatusNotification")
                }
                self.stopBackgroundTaskRequest()
            }
            healthStore.execute(query)
        } else {
            FFHealthDataAccess.shared.requestForAccessToHealth()
        }
        
    }
    ///функция теста для вызова уведомления о количестве шагов пройденных пользователем
    func sendLocalNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Congratulations"
        content.body = "You have reached 10 0000 steps count. Don't stop on this result"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Malkov.KS.FeelFit.fitness.notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Did not complete to send notification. \(error.localizedDescription)")
            }
        }
    }
    
    
    private func selectDataTypeIdentifier(_ dataTypeIdentifier: HKQuantityTypeIdentifier){
        userDefaults.setValue(dataTypeIdentifier.rawValue, forKey: "dataTypeIdentifier")
        self.dataTypeIdentifier = dataTypeIdentifier.rawValue
        self.didTapRefreshView()
    }
    
    func dateIntervalConfiguration(_ type: HealthModelDate = .week) -> DateComponents {
        var interval = DateComponents()
        switch type {
        case .week,.month:
            interval = DateComponents(day: 1)
        case .sixMonth:
            interval = DateComponents(weekday: 1)
        case .year:
            interval = DateComponents(month: 1)
        }
        return interval
    }
    
    func uploadSelectedData(id: String = "HKQuantityTypeIdentifierStepCount",dateType: HealthModelDate = .week,data completion: @escaping (([HealthModelValue]) -> Void)){
        if isHealthKitAccess {
            var value: [HealthModelValue] = [HealthModelValue]()
            let identifier = HKQuantityTypeIdentifier(rawValue: id)
            guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
            let now = Date()
            let (withStartDate,startOfDay) = dateRangeConfiguration(type: dateType)
            
            let interval = dateIntervalConfiguration(dateType)
            var options: HKStatisticsOptions = []
            if id == HKQuantityTypeIdentifier.heartRate.rawValue {
                options = .discreteAverage
            } else {
                options = .cumulativeSum
            }
            let predicate = HKQuery.predicateForSamples(withStart: withStartDate, end: now, options: .strictEndDate)
            let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                    quantitySamplePredicate: predicate,
                                                    options: options,
                                                    anchorDate: startOfDay,
                                                    intervalComponents: interval)
            query.initialResultsHandler = { /*[weak self] */ query, results, error in
                guard error == nil,
                    let results = results else {
                    let title = "Error getting initial results with handler"
                    print(title)
                    return
                }
                results.enumerateStatistics(from: withStartDate, to: now) {  stats, stop in
                    let startDate = stats.startDate
                    switch identifier {
                    case .stepCount:
                        let unit = HKUnit.count()
                        guard let steps = stats.sumQuantity()?.doubleValue(for: unit) else { return }
                        value.append(HealthModelValue.init(date: startDate, value: steps,unit: unit,identifier: id))
                    case .distanceWalkingRunning:
                        let unit = HKUnit.meter()
                        guard let meters = stats.sumQuantity()?.doubleValue(for: unit) else { return }
                        value.append(HealthModelValue.init(date: startDate, value: meters,unit: unit,identifier: id))
                    case .activeEnergyBurned:
                        let unit = HKUnit.kilocalorie()
                        guard let calories = stats.sumQuantity()?.doubleValue(for: unit) else { return }
                        value.append(HealthModelValue.init(date: startDate, value: calories,unit: unit,identifier: id))
                    case .heartRate:
                        let unit = HKUnit.count().unitDivided(by: .minute())
                        guard let heartRate = stats.averageQuantity()?.doubleValue(for: unit) else { return }
                        value.append(HealthModelValue.init(date: startDate, value: heartRate,unit: unit,identifier: id))
                        
                    default: fatalError("Error getting data from health kit")
                    }
                    
                }
                //MARK: - Функция добавления данных в OCKStore. Пока не работает, чуть позже будет
//                self?.saveDataToCareKitStore(value)
                completion(value)
                
            }
            healthStore.execute(query)
        } else {
            FFHealthDataAccess.shared.requestForAccessToHealth()
        }
    }
    
    func dateRangeConfiguration(type: HealthModelDate) -> (startDate: Date, endDate: Date)  {
        let endDate = calendar.startOfDay(for: Date())
        var startDate = Date()
        switch type {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -6, to: endDate)!
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: endDate)!
        case .sixMonth:
            startDate = calendar.date(byAdding: .month, value: -6, to: endDate)!
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: endDate)!
        }
        return (startDate, endDate)
    }
    
    func saveDataToCareKitStore(_ values: [HealthModelValue]) {
        guard let model = (values.first) else { return }
        let taskId = OCKLocalVersionID(model.identifier)
        let unit = values.first?.unit
        var outcomeValue = [OCKOutcomeValue]()
        for value in values {
            let outcomeValueStep = value.value as OCKOutcomeValueUnderlyingType
            outcomeValue.append(OCKOutcomeValue(outcomeValueStep, units: unit?.unitString))
        }
        let outcome = OCKOutcome(taskID: taskId, taskOccurrenceIndex: 0, values: outcomeValue)
        careKitStore.addOutcome(outcome) { result in
            switch result {
            case .success(_):
                print("Saved to OCKStore successfully")
            case .failure(_):
                print("Did not saved to OCKStore successfully")
            }
        }
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
        tableView.setupAppearanceShadow()
    }
    
    func setupScrollView(){
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.refreshControl = refreshControl
        scrollView.alwaysBounceVertical = true
    }
    
    func setupRefreshControl(){
        refreshControl.addTarget(self, action: #selector(didTapRefreshView), for: .valueChanged)
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
        isHealthKitAccess = UserDefaults.standard.bool(forKey: "healthKitAccess")
    }
    
    func setupNavigationController() {
        title = "Health"
        openProfileButton.addTarget(self, action: #selector(didTapOpenProfile), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: openProfileButton)
    }
    
    func setupViewModel() {
        viewModel = FFHealthViewModel(viewController: self)
    }
}

extension FFHealthViewController: OCKChartViewDelegate {
    func didSelectChartView(_ chartView: UIView & CareKitUI.OCKChartDisplayable) {
        if chartView == activityChartView {
            didTapOpenChart()
        }
    }
}


extension FFHealthViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  FFHealthTableViewCell.identifier, for: indexPath) as! FFHealthTableViewCell
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
        let headerView = FFHealthTableViewHeaderFooterView()
        headerView.headerButton.addTarget(self, action: #selector(didTapChooseLoadingType), for: .primaryActionTriggered)
        headerView.configureHeader(title: titleForTable, #selector(didTapChooseLoadingType))
        return headerView
    }
}

extension FFHealthViewController {
    
    private func setupConstraints(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(refreshControl)
        
        
        scrollView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview()
        }
        
        scrollView.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalTo(scrollView.snp.width).multipliedBy(0.9)
        }
    
        chartView.addSubview(setupChartButton)
        setupChartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(40)
        }
        
        scrollView.addSubview(segmentController)
        segmentController.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(40)
        }
        
        
        scrollView.addSubview(activityChartView)
        activityChartView.snp.makeConstraints { make in
            make.top.equalTo(segmentController.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalTo(scrollView.snp.width).multipliedBy(0.9)
        }
        
        
        
        scrollView.snp.makeConstraints { make in
            make.bottom.equalTo(activityChartView.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width)
        }
    }
}


///uploading VO 2 MAX and convert to average data for every last 6  months and return HealthModelValue array
/*
private func uploadAverageOxygenData(completion: @escaping (_ model: [HealthModelValue]) -> ()){
    let identifier = HKObjectType.quantityType(forIdentifier: .vo2Max)!
    let startDate = calendar.date(byAdding: .month, value: -6, to: Date())!
    let endDate = calendar.date(byAdding: .month, value: 1, to: Date())!
        .startOfMonth()
        .addingTimeInterval(-1)
    let interval = DateComponents(month: 1)
    let kgmin = HKUnit.gramUnit(with: .kilo).unitMultiplied(by: .minute())
    let mL = HKUnit.literUnit(with: .milli)
    let vo2unit = mL.unitDivided(by: kgmin)
    
    var healthModel: [HealthModelValue] = [HealthModelValue]()
    let query = HKStatisticsCollectionQuery(quantityType: identifier, quantitySamplePredicate: nil, options: [.discreteAverage], anchorDate: startDate, intervalComponents: interval)
    
    
    query.initialResultsHandler = { query, results, error in
        guard let results = results else {
            return
        }
        results.enumerateStatistics(from: startDate, to: endDate) { stats, _ in
            let month = stats.startDate
            guard let average = stats.averageQuantity()?.doubleValue(for: vo2unit) else {
                return
            }
            healthModel.append(HealthModelValue(date: month, value: average,unit: vo2unit,identifier: identifier.identifier))
        }
        completion(healthModel)
    }
    healthStore.execute(query)
}*/
