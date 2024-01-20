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
import WatchConnectivity


struct HealthModelValue {
    let date: Date
    let value: Double
}

class FFHealthViewController: UIViewController, SetupViewController {
    
    private let healthStore = HKHealthStore()
    private let careKitStore = OCKStore(name: "UserDataStore",type: .inMemory)
    private let readTypes = Set(FFHealthData.readDataTypes)
    private let shareTypes = Set(FFHealthData.shareDataTypes)
    private let userDefaults = UserDefaults.standard
    private let watchSession = WCSession.default
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupConstraints()
        setupChartView()
        setupScrollView()
        
        
        if isHealthKitAccess {
            setupBackgroundTask()
            requestAccessToBackgroundMode()
        }
    }

    
    //MARK: - Setup CareKit chart
    func setupChartView(){
        chartView.delegate = self
        chartView.contentStackView.distribution = .fillProportionally
        
        chartView.headerView.titleLabel.text = titleForTable
        chartView.headerView.detailLabel.text = createChartWeeklyDateRangeLabel() //Добавление в детейл лейблам даты
        
        chartView.applyConfiguration()
        chartView.graphView.horizontalAxisMarkers = createHorizontalAxisMarkers()
        uploadSelectedData { value in
            let stepValues: [CGFloat] = value.map { CGFloat($0.value) }
            DispatchQueue.main.async {
                self.chartView.graphView.dataSeries = [
                    OCKDataSeries(values: stepValues, title: "Steps")
                ]
            }
        }
    }
    //MARK: - UIApplication background task
    func setupBackgroundTask(){
        UIApplication.shared.isIdleTimerDisabled = true
        backgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: "Malkov.KS.FeelFit.health_data_refresh", expirationHandler: { [weak self] in
            self?.stopBackgroundTaskRequest()
        })
        
        //repeat check value every 10 minutes in background
        timer = Timer.scheduledTimer(withTimeInterval: 60*10, repeats: true, block: { [unowned self] _ in
            DispatchQueue.global(qos: .background).async {
                self.setupObserverQuery()
            }
        })
    }
    
    func stopBackgroundTaskRequest(){
        UIApplication.shared.endBackgroundTask(self.backgroundTaskId)
        self.backgroundTaskId = .invalid
        stopCountingSteps()
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
        let calendar = Calendar.current
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
                print(error.localizedDescription)
            }
        }
    }
    //функция для создания предиката для запроса данных за последний день и создание наблюдателя для получения обновлений
    func setupObserverQuery(){
        let calendar = Calendar.current
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
            print("Количество шагов обновленно")
            guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
            let calendar = Calendar.current
            let now = Date()
            let startOfDay = calendar.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
            
            let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate) { [unowned self] query, stats, error in
                guard error == nil else {
                    print(String(describing:error?.localizedDescription))
                    return
                }
                guard let result = stats else { return }
                guard let stepCount = result.sumQuantity()?.doubleValue(for: .count()) else { return }
                
                if stepCount >= 10_000 && !self.shouldSendNotification() {
                    self.sendLocalNotification()
                    self.userDefaults.set(true, forKey: "sendStatusNotification")
                } else {
                    print("Steps count is \(stepCount)")
                }
                self.stopBackgroundTaskRequest()
            }
            healthStore.execute(query)
        } else {
            FFHealthDataAccess.shared.requestForAccessToHealth()
        }
        
    }
    //MARK: - DONT DELETE
    ///function for collecting steps count from apple watch if it is available
    func queryStepCountFromWatch(completion: @escaping (Result<Int,Error>) -> ()){
        if WCSession.isSupported() {
            if watchSession.isPaired && watchSession.isWatchAppInstalled {
                watchSession.sendMessage(["request":"stepCount"]) { (reply) in
                    guard let steps = reply["stepCount"] as? Int else { return }
                    completion(.success(steps))
                } errorHandler: { error in
                    completion(.failure(error))
                }
            }
        } else {
            print("Apple watch is unavailable")
        }
    }
    
    ///функция теста для вызова уведомления о количестве шагов пройденных пользователем
    func sendLocalNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Congratulations"
        content.body = "You have reached 10 0000 steps count. Don't stop on this result"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Malkov.KS.FeelFit.notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Did not complete to send notification. \(error.localizedDescription)")
            }
        }
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
        
        
        self.tableView.reloadRows(at: fixedIndexPath, with: .fade)
        self.tableView.reloadData()
    }
    
    func uploadSelectedData(id: String = "HKQuantityTypeIdentifierStepCount",data completion: @escaping (([HealthModelValue]) -> Void)){
        if isHealthKitAccess {
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
                        value.append(HealthModelValue.init(date: startDate, value: steps))
                    case .distanceWalkingRunning:
                        guard let meters = stats.sumQuantity()?.doubleValue(for: HKUnit.meter()) else { return }
                        value.append(HealthModelValue.init(date: startDate, value: meters))
                    case .activeEnergyBurned:
                        guard let calories = stats.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) else { return }
                        value.append(HealthModelValue(date: startDate, value: calories))
                    default: fatalError("Error getting data from health kit")
                    }
                    
                }
                completion(value)
                
            }
            healthStore.execute(query)
        } else {
            FFHealthDataAccess.shared.requestForAccessToHealth()
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
    }
    
    func setupScrollView(){
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.isScrollEnabled = true
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

extension FFHealthViewController: OCKChartViewDelegate {
    func didSelectChartView(_ chartView: UIView & CareKitUI.OCKChartDisplayable) {
        //попробовать к примеру при нажатии на chartView переход на отдельный контроллер для показа всех деталей
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
        let mainView = UIView(frame: CGRect(x: 5, y: 5, width: tableView.frame.size.width-10, height: 40))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: mainView.frame.size.width-90, height: 40))
        label.font = UIFont.headerFont(size: 24)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = FFResources.Colors.detailTextColor
        label.text = titleForTable
        
        let button = UIButton(frame: CGRect(x: mainView.frame.size.width-90, y: 10,width: 60, height: mainView.frame.size.height-5))
        button.configuration = .tinted()
        button.configuration?.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        button.configuration?.baseForegroundColor = FFResources.Colors.activeColor
        button.configuration?.baseBackgroundColor = FFResources.Colors.textColor
        button.configuration?.cornerStyle = .capsule
        button.addTarget(self, action: #selector(didTapChooseLoadingType), for: .touchUpInside)
        
        mainView.addSubview(label)
        mainView.addSubview(button)
        return mainView
    }
}

extension FFHealthViewController {
    private func setupConstraints(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
        
        scrollView.snp.makeConstraints { make in
            make.bottom.equalTo(chartView.snp.bottom)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(tableView.snp.height).offset(view.frame.height/2)
        }
    }
}
