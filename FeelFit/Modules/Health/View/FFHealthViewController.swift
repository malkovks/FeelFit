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


struct HealthModelValue {
    let date: Date
    let value: Double
}

class FFHealthViewController: UIViewController, SetupViewController {
    
    private let healthStore = HKHealthStore()
    private let readTypes = Set(FFHealthData.readDataTypes)
    private let shareTypes = Set(FFHealthData.shareDataTypes)
    private let userDefaults = UserDefaults.standard
    private let taskId = "Malkov.KS.FeelFit.backgroundTask"
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
    
    private var hasRequestedHealthData: Bool = false
    private var dataTypeIdentifier: String = UserDefaults.standard.string(forKey: "dataTypeIdentifier") ?? "HKQuantityTypeIdentifierStepCount"
    private var titleForTable: String {
        return getDataTypeName(HKQuantityTypeIdentifier(rawValue: dataTypeIdentifier))
    }
    private var healthModel: [HealthModelValue] = [HealthModelValue]()
    
    private var tableView: UITableView!
    //TEST VALUE
    var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupViewModel()
        setupTableView()
        getHealthAuthorizationRequestStatus()
        setupConstraints()
        requestForAccessToHealth()
        
        
        self.scheduleBackgroundTask()
        setupBackgroundTask()
    } 
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //отменяем наблюдателя при выходе из контроллера
        //предполагаю если мы переходим на другой контроллер
        if let observerQuery = observerQuery {
            healthStore.stop(observerQuery)
            print("health observer is cancelled")
        }
    }
    
    //MARK: - UIApplication background task
    func setupBackgroundTask(){
        UIApplication.shared.isIdleTimerDisabled = true
        backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "healthKitDataLoading", expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
            self.backgroundTaskID = .invalid
        })
        
        timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true, block: { [unowned self] _ in
            DispatchQueue.global(qos: .background).async {
                self.setupObserverQuery()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        })
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
    func requestAccessToBackgroundMode(_ success: Bool) {
        if success {
            guard let steps = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
            healthStore.enableBackgroundDelivery(for: steps, frequency: .immediate) { status, error in
                if success {
                    print("Доступ к фоновой загрузке разрешен")
                } else {
                    print("Доступ запрещен. \(String(describing:error?.localizedDescription))")
                }
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
        print("Количество шагов обновленно")
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate) { query, stats, error in
            guard error == nil else {
                print(String(describing:error?.localizedDescription))
                return
            }
            
            guard let result = stats else { return }
            guard let stepCount = result.sumQuantity()?.doubleValue(for: .count()) else { return }
            
            if stepCount >= 10_000 && !self.shouldSendNotification() {
                self.sendLocalNotification(steps: stepCount)
                self.userDefaults.set(true, forKey: "sendStatusNotification")
            } else {
                print("Steps count is \(stepCount)")
            }
            
        }
        healthStore.execute(query)
    }
    
   
    
    //MARK: - Setup Background Modes
    func updateData(){
        //вызов функции получения количества шагов пользователя
        print("Вызов функции update data")
    }
    
    // функция не используется (пока оставляем)
    func scheduleAppRefresh(){
        let request = BGAppRefreshTaskRequest(identifier: taskId)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60.0)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Не удалось запустить задачу \(error.localizedDescription)")
        }
    }
    ///функция теста для вызова уведомления о количестве шагов пройденных пользователем
    func sendLocalNotification(steps: Double){
        let stepsInt = Int(exactly: steps)
        let steps = String(describing: stepsInt)
        let content = UNMutableNotificationContent()
        content.title = "Congratulations"
        content.body = "You have reached \(steps) steps count. Don't stop on this result"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Malkov.KS.FeelFit.notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Did not complete to send notification. \(error.localizedDescription)")
            }
        }
    }
    
    //Функция из видео для настройки фонового выполнения задачи. Непонятно пока как работает
    func scheduleBackgroundTask(){
        
        //Manual test : e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"Malkov.KS.FeelFit.backgroundTask"]
        
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskId)
        BGTaskScheduler.shared.getPendingTaskRequests { [unowned self] request in
            
            print("\(request.count) BGTasks pending....")
            guard request.isEmpty else {
                print("Error. Requests is empty")
                return
            }
            
            do {
                let newTask = BGAppRefreshTaskRequest(identifier: self.taskId)
                newTask.earliestBeginDate = Date(timeIntervalSinceNow: 60.0)
                try BGTaskScheduler.shared.submit(newTask)
                print("Task scheduled")
            } catch {
                //ignore
                print("Failed to scheduled: \(error.localizedDescription)")
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
    
    private func requestForAccessToHealth(){
        var textStatus: String = ""
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) {[unowned self] success, error in
            if let error = error {
                textStatus = "Applications gets error by trying to get access to Health. \(error.localizedDescription)"
            } else {
                requestAccessToBackgroundMode(success)
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(5)
        }
    }
}
