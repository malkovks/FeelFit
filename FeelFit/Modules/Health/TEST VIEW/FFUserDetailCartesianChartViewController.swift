//
//  FFUserDetailCartesianChartViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.02.2024.
//

import UIKit
import CareKit
import HealthKit



class FFUserDetailCartesianChartViewController: UIViewController, SetupViewController {
    
    private var chartDataProvider: [FFUserHealthDataProvider]
    
    init(chartData: [FFUserHealthDataProvider]){
        self.chartDataProvider = chartData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let calendar = Calendar.current
    private let healthStore = HKHealthStore()
    private let userDefaults = UserDefaults.standard
    private let loadUserHealth = FFHealthDataLoading.shared
    
    private var selectedDateType = UserDefaults.standard.string(forKey: "healthDateType") ?? FFHealthDateType.week.rawValue
    private var selectedDateIdentifier = UserDefaults.standard.string(forKey: "healthDateIdentifier") ?? "HKQuantityTypeIdentifierStepCount"
    private var userImagePartialName = UserDefaults.standard.string(forKey: "userProfileFileName") ?? "userImage.jpeg"
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.tintColor = FFResources.Colors.activeColor
        return refresh
    }()
    
    private let segmentControl: UISegmentedControl = {
        let titles = ["Day","Week","Month","Year"]
        let segmentControl = UISegmentedControl(items: titles)
        segmentControl.apportionsSegmentWidthsByContent = true
        segmentControl.selectedSegmentTintColor = FFResources.Colors.activeColor
        segmentControl.layer.borderWidth = 0.3
        segmentControl.layer.borderColor = FFResources.Colors.darkPurple.cgColor
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
        chart.headerView.detailLabel.text = createChartWeeklyDateRangeLabel(startDate: nil)
        chart.applyConfiguration()
        chart.graphView.horizontalAxisMarkers = createHorizontalAxisMarkers()
        chart.backgroundColor = .systemBackground
        chart.layer.borderWidth = 0.3
        chart.layer.borderColor = FFResources.Colors.darkPurple.cgColor
        return chart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    //MARK: - Target and action methods
    @objc private func handleRefreshControl(_ sender: UIRefreshControl){
        refreshCartesianView()
        DispatchQueue.main.async {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func didTapOpenFullData(){
        let vc = FFHealthViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///Сделать отображение выбранной даты формата в лейбл в граф вью
    ///Разобраться с сортировкой и с тем что и как загружается при выборе секций
    ///Настроить функцию под универсальное пользование
    @objc private func handlerSegmentController(_ sender: UISegmentedControl){
        var calendar: Calendar.Component?
        var components = DateComponents()
        var interval: Int = 0
        switch sender.selectedSegmentIndex {
        case 0:
            calendar = .day
            interval = -1
            components.hour = 1
        case 1:
            calendar = .day
            interval = -6
            components.day = 1
        case 2:
            calendar = .day
            interval = -28
            components.day = 7
        case 4:
            calendar = .month
            interval = -12
            components.month = 1
        default:
            break
        }
//        let startDate = createLastWeekStartDate(from: Date(), byAdding: calendar ?? .day, value: interval)
        let startDate = Calendar.current.startOfDay(for: Date())
        
        guard let identifier = chartDataProvider.first?.typeIdentifier else { return }
        loadUserHealth.performQuery(identifications: [identifier],
                                    value: components,
                                    interval: interval,
                                    selectedOptions: nil,
                                    startDate: startDate,
                                    currentDate: Date()) { models in
            self.chartDataProvider = models!
            self.updateChartDataSeries()
            
        }
        userDefaults.set(sender.selectedSegmentIndex, forKey: "selectedSegmentControl")
    }
    
    @objc private func didTapPopToRoot(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapPresentUserProfile(){
        let vc = FFHealthUserProfileViewController()
        present(vc, animated: true)
    }
    
    @objc private func didTapCreateNewValue(){
        guard let identifier = chartDataProvider.first?.typeIdentifier else { return }
        let title = getDataTypeName(identifier)
        let message = "Enter a value to add a sample to your health data."
        manualEnterHealthData(title, message) { [weak self] result in
            self?.didAddNewData(with: result)
        }
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
        chartView.delegate = self
        chartView.isUserInteractionEnabled = true
        chartView.graphView.isUserInteractionEnabled = true 
        updateChartDataSeries()
    }
    
    private func refreshCartesianView(interval dateComponents: DateComponents = DateComponents(day: 1)){
        guard let identifier = chartDataProvider.first?.typeIdentifier else { return }
        FFHealthDataLoading.shared.performQuery(identifications: [identifier],value: dateComponents, selectedOptions: nil,startDate: nil) { [weak self] models in
            if let data = models {
                self?.chartDataProvider = data
                self?.updateChartDataSeries()
            } else {
                self?.viewAlertController(text: "Error loading selected identifier", startDuration: 0.5, timer: 2, controllerView: self!.view)
            }
        }
    }
    
    private func updateChartDataSeries(){
        guard let firstChartData = chartDataProvider.last,
              let identifier = firstChartData.typeIdentifier else {
            return
        }
        let chartTitle = getDataTypeName(identifier)
        
        let measurementUnitText = getUnitMeasurement(identifier)
        
        let value: [CGFloat] = chartDataProvider.map { CGFloat($0.value) }
        
        let series = OCKDataSeries(values: value, title: measurementUnitText.capitalized ,size: 2.0, color: FFResources.Colors.activeColor)
        
        DispatchQueue.main.async { [weak self] in
            self?.chartView.graphView.dataSeries = [series]
            self?.chartView.headerView.titleLabel.text = chartTitle
        }
    }
    
    private func setupScrollView(){
        scrollView.refreshControl = refreshControl
        scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    func setupNavigationController() {
        let text  = getDataTypeName(chartDataProvider.first?.typeIdentifier ?? .stepCount)
        title = text
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "Back", imageName: "", action: #selector(didTapPopToRoot), menu: nil)
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "", imageName: "plus", action: #selector(didTapCreateNewValue), menu: nil)
    }
    
    private func setupSegmentControl(){
        segmentControl.selectedSegmentIndex = userDefaults.value(forKey: "selectedSegmentControl") as? Int ?? 1
        segmentControl.addTarget(self, action: #selector(handlerSegmentController), for: .valueChanged)
    }
    
    func setupViewModel() {
        
    }
}

private extension FFUserDetailCartesianChartViewController {
    func didAddNewData(with value: Double) {
        guard let sample = processHealthSample(with: value, data: chartDataProvider) else { return }
        FFHealthData.saveHealthData([sample]) { success, error in
            if let error = error {
                print("FFUserDetailCartesianChartViewController  didAddNewData error: ",error.localizedDescription)
            }
            if success {
                print("Saved successfully")
                DispatchQueue.main.async { [weak self] in
                    self?.updateChartDataSeries()
                }
            } else {
                print("error: could now save new sample", sample)
            }
        }
                
    }
    
    func processHealthSample(with value: Double,data provider: [FFUserHealthDataProvider]) -> HKObject? {
        guard 
            let provider = provider.first,
            let id = provider.typeIdentifier
        else {
            return nil
        }
        let idString = provider.identifier
        
        
        let sampleType = getSampleType(for: idString)
        guard let unit = prepareHealthUnit(id) else { return nil }
        
        let now = Date()
        let start = now
        let end = now
        
        var optionalSample: HKObject?
        if let quantityType = sampleType as? HKQuantityType {
            let quantity = HKQuantity(unit: unit, doubleValue: value)
            let quantitySample = HKQuantitySample(type: quantityType, quantity: quantity, start: start, end: end)
            optionalSample = quantitySample
        }
        if let categoryType = sampleType as? HKCategoryType {
            let categorySample = HKCategorySample(type: categoryType, value: Int(value), start: start, end: end)
            optionalSample = categorySample
        }
        
        return optionalSample
    }
}

extension FFUserDetailCartesianChartViewController: OCKChartViewDelegate {
    func didSelectChartView(_ chartView: UIView & CareKitUI.OCKChartDisplayable) {
        guard let chart = chartView as? OCKCartesianChartView else { return }
        let index = chart.graphView.selectedIndex!
        print(index)
        let data = chartDataProvider[index]
        let valueString = String(describing: data.value) + " "
        let valueType = getUnitMeasurement(data.typeIdentifier!)
        alertError(title: "Data value on this day", message: valueString + valueType)
    }
}

private extension FFUserDetailCartesianChartViewController {
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
