//
//  FFMainHealthDataViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.02.2024.
//

import UIKit
import CareKit
import HealthKit



class FFMainHealthDataViewController: UIViewController, SetupViewController {
    
    private let calendar = Calendar.current
    private let healthStore = HKHealthStore()
    private let userDefaults = UserDefaults.standard
    
    private var selectedDateType = UserDefaults.standard.string(forKey: "healthDateType") ?? FFHealthDateType.week.rawValue
    private var selectedDateIdentifier = UserDefaults.standard.string(forKey: "healthDateIdentifier") ?? "HKQuantityTypeIdentifierStepCount"
    private var userImagePartialName = UserDefaults.standard.string(forKey: "userProfileFileName") ?? "userImage.jpeg"
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.tintColor = FFResources.Colors.activeColor
        return refresh
    }()
    
    private let segmentControl: UISegmentedControl = {
        let titles = ["Day","Week","Month","Half Year","Year"]
        let segmentControl = UISegmentedControl(items: titles)
        segmentControl.apportionsSegmentWidthsByContent = true
        segmentControl.selectedSegmentTintColor = FFResources.Colors.activeColor
        segmentControl.layer.borderWidth = 0.3
        segmentControl.layer.borderColor = FFResources.Colors.textColor.cgColor
        return segmentControl
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .secondarySystemBackground
        return scrollView
    }()
    
    private let chartView: OCKCartesianChartView = {
        let chart = OCKCartesianChartView(type: .bar)
        chart.headerView.titleLabel.text = "Title label text"
        chart.headerView.detailLabel.text = createChartWeeklyDateRangeLabel(startDate: nil)
        chart.applyConfiguration()
        chart.graphView.horizontalAxisMarkers = createHorizontalAxisMarkers()
        chart.backgroundColor = .systemBackground
        chart.layer.borderWidth = 0.3
        chart.layer.borderColor = FFResources.Colors.textColor.cgColor
        return chart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    //MARK: - Target and action methods
    @objc private func handleRefreshControl(_ sender: UIRefreshControl){
        DispatchQueue.main.async {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func didTapOpenFullData(){
        let vc = FFHealthViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handlerSegmentController(_ sender: UISegmentedControl){
        var type: FFHealthDateType = .day
        switch sender.selectedSegmentIndex {
        case 0:
            type = FFHealthDateType.day
        case 1:
            type = FFHealthDateType.week
        case 2:
            type = FFHealthDateType.month
        case 3:
            type = FFHealthDateType.sixMonth
        case 4:
            type = FFHealthDateType.year
        default:
            break
        }
        userDefaults.setValue(type.rawValue, forKey: "healthDateType")
        selectedDateType = type.rawValue
        
    }
    
    @objc private func didTapPresentUserProfile(){
        let vc = FFHealthUserProfileViewController()
        present(vc, animated: true)
    }
    
    
    /// Function loading selected type from HealthStore ,convert and display in correct form
    /// - Parameters:
    ///   - type: necessary for set up period of loading data
    ///   - identifier: it is HKQuantityTypeIdentifier of selected type for downloading information
    ///   - completionHandler: return array of FFUserHealthDataProvider
    private func uploadHealthDataBy(type: FFHealthDateType = .week,_ identifier: String = "HKQuantityTypeIdentifierStepCount",completionHandler: @escaping ((_ userData: [FFUserHealthDataProvider]) -> ()) ){
        var returnValue: [FFUserHealthDataProvider] = [FFUserHealthDataProvider]()
        let quantityType = prepareQuantityType(identifier)
        let predicate = preparePredicateHealthData(type)
        let interval = FFHealthData.dateIntervalConfiguration(type)
        let date = FFHealthData.dateRangeConfiguration(type)
        let options = HKStatisticsOptions.cumulativeSum
        
        let query: HKStatisticsCollectionQuery = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: options,
            anchorDate: date.endDate,
            intervalComponents: interval)
        
        query.initialResultsHandler = { queries, results, error in
            guard error == nil,
                  let results = results else {
                print("Error getting result from query. Try again of fix it")
                return
            }
            
            results.enumerateStatistics(from: date.startDate, to: date.endDate) { stats, pointer in
                //setups for step count
                let unit = HKUnit.count()
                let startDate = stats.startDate
                let endDate = stats.endDate
                let type = stats.quantityType
                guard let steps = stats.sumQuantity()?.doubleValue(for: unit) else { return }
                let value = FFUserHealthDataProvider(startDate: startDate, endDate: endDate, value: steps, identifier: identifier, unit: unit, type: type)
                returnValue.append(value)
            }
            completionHandler(returnValue)
        }
        healthStore.execute(query)
    }
    ///Function creating predicate based on HKQuery and input startDate and endDate in this diapason
    private func preparePredicateHealthData(_ type: FFHealthDateType) -> NSPredicate{
        let (startDate,endDate) = FFHealthData.dateRangeConfiguration(type)
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
    }
    
    /// Function creating, check optional and return quantity type
    /// - Parameter identifier: string identifier of what function must return
    /// - Returns: return completed quantity type if it not nil or no error. If any error return HKQuantityType.stepCount
    private func prepareQuantityType(_ identifier: String) -> HKQuantityType {
        let quantityIdentifier = HKQuantityTypeIdentifier(rawValue: identifier)
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: quantityIdentifier) else { return HKQuantityType(.stepCount)}
        return quantityType
    }
    
    //MARK: - Setup Methods
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupNavigationController()
        setupViewModel()
        setupScrollView()
        setupChartView()
        
        setupConstraints()
        setupSegmentControl()
    }
    
    private func setupChartView(){
        FFHealthDataLoading.shared.uploadHealthDataBy { userData in
            let value: [CGFloat] = userData.map { CGFloat($0.value) }
            let series = OCKDataSeries(values: value, title: "Steps",size: 2, color: .black)
            DispatchQueue.main.async {
                self.chartView.graphView.dataSeries.append(series)
            }
        }
    }
    
    private func setupScrollView(){
        scrollView.refreshControl = refreshControl
        scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    func setupNavigationController() {
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "", imageName: "info.circle", action: #selector(didTapOpenFullData), menu: nil)
        let button = setupNavigationButton()
        let leftBarButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    private func setupNavigationButton() -> UIButton {
//        let image = loadUserImageWithFileManager(userImagePartialName)
        let image = UIImage(systemName: "person.circle")
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapPresentUserProfile), for: .primaryActionTriggered)
        return button
    }
    
    private func setupSegmentControl(){
        if let index = FFHealthDateType.index(forRawValue: selectedDateType) {
            segmentControl.selectedSegmentIndex = index
        } else {
            segmentControl.selectedSegmentIndex = 0
        }
        
        segmentControl.addTarget(self, action: #selector(handlerSegmentController), for: .valueChanged)
    }
    
    func setupViewModel() {
        
    }
    
    
}

private extension FFMainHealthDataViewController {
    func setupConstraints(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        scrollView.snp.makeConstraints { make in
            make.bottom.equalTo(chartView.snp.bottom).offset(10)
        }
    }
}
