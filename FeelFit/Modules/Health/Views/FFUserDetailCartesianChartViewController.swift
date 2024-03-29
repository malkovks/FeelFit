//
//  FFUserDetailCartesianChartViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.02.2024.
//

import UIKit
import CareKit
import HealthKit


/// Class displaying selected identifier,add access to add data to healthStore for user and change periods of displaying data
class FFUserDetailCartesianChartViewController: UIViewController, SetupViewController {
    
    private let identifier: HKQuantityTypeIdentifier
    
    init(typeIdentifier: HKQuantityTypeIdentifier){
        self.identifier = typeIdentifier
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var chartDataProvider = [FFUserHealthDataProvider]()
    
    private let calendar = Calendar.current
    private let healthStore = HKHealthStore()
    private let userDefaults = UserDefaults.standard
    private let loadUserHealth = FFHealthDataLoading.shared
    
    private var userImagePartialName = UserDefaults.standard.string(forKey: "userProfileFileName") ?? "userImage.jpeg"
    
    private var startDate: Date? = createLastWeekStartDate()
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.tintColor = FFResources.Colors.activeColor
        return refresh
    }()
    
    private let segmentControl: UISegmentedControl = {
        let titles = ["Day","Week","Month"]
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
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = FFResources.Colors.activeColor
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    //MARK: - Target and action methods
    @objc private func handleRefreshControl(){
        loadSelectedData(startDate: self.startDate, headerLabel: "")
        DispatchQueue.main.async {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func handlerSegmentController(_ sender: UISegmentedControl){
        isData(loading: true)
        var components = DateComponents()
        var headerDetailLabelText = ""
        var interval: Int = 0
        switch sender.selectedSegmentIndex {
        case 0:
            interval = -1
            components.hour = 1
            headerDetailLabelText = "24 Hours"
            self.chartView.graphView.horizontalAxisMarkers = createHorizontalAxisMarkersForDay()
            self.startDate = Calendar.current.startOfDay(for: Date())
        case 1:
            interval = -6
            components.day = 1
            self.startDate = createLastWeekStartDate()
            headerDetailLabelText = createChartWeeklyDateRangeLabel(startDate: nil)
        case 2:
            interval = -30
            components.day = 1
            self.startDate = createLastWeekStartDate(from: Date(), byAdding: .day, value: -30)
            headerDetailLabelText = createChartWeeklyDateRangeLabel(startDate: self.startDate)
            self.chartView.graphView.horizontalAxisMarkers = generateWeeklyDateIntervals()
        default:
            break
        }
        
        loadSelectedData(components: components, interval: interval, startDate: self.startDate, headerLabel: headerDetailLabelText)
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
        let title = getDataTypeName(self.identifier)
        
        let message = "Enter a value to add a sample to your health data."
        
        presentTextFieldAlertController(placeholder: title, keyboardType: .numberPad, alertTitle: title,message: message) { [weak self] text in
            guard let doubleValue = Double(text) else { return }
            self?.didAddNewData(with: doubleValue)
        }
    }
    
    //MARK: - Setup Methods
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupSegmentControl()
        setupNavigationController()
        setupViewModel()
        setupScrollView()
        setupChartView()
        
        setupConstraints()
    }
    
    private func setupChartView(){
        chartView.delegate = self
        chartView.isUserInteractionEnabled = true
        chartView.graphView.isUserInteractionEnabled = true 
        loadSelectedData(startDate: startDate, headerLabel: "")
    }
    
    private func loadSelectedData(components: DateComponents = DateComponents(day: 1),interval: Int = -6,startDate: Date?,headerLabel: String?){
        loadUserHealth.performQuery(identifications: [self.identifier],
                                    value: components,
                                    interval: interval,
                                    selectedOptions: nil,
                                    startDate: startDate,
                                    currentDate: Date()) { [weak self] models in
            guard let models = models else {
                self?.viewAlertController(text: "Did not get data. Try later", startDuration: 0.5, timer: 2, controllerView: self!.view)
                return
            }
            self?.chartDataProvider = models
            self?.updateChartDataSeries()
            DispatchQueue.main.async {
                self?.chartView.headerView.detailLabel.text = headerLabel
                self?.isData(loading: false)
            }
        }
    }
    
    private func updateChartDataSeries(){
        let chartTitle = getDataTypeName(identifier)
        
        let measurementUnitText = getUnitMeasurement(identifier)
        
        let value: [CGFloat] = chartDataProvider.map { CGFloat($0.value) }
        
        let series = OCKDataSeries(values: value, title: measurementUnitText.capitalized ,size: 2.0, color: FFResources.Colors.activeColor)
        
        DispatchQueue.main.async { [weak self] in
            self?.chartView.graphView.dataSeries = [series]
            self?.chartView.headerView.titleLabel.text = chartTitle
        }
    }
    
    private func isData(loading status: Bool) {
        if status {
            chartView.isHidden = true
            indicatorView.startAnimating()
        } else {
            chartView.isHidden = false
            indicatorView.stopAnimating()
        }
    }
    
    private func setupScrollView(){
        scrollView.refreshControl = refreshControl
        scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    func setupNavigationController() {
        let text  = getDataTypeName(identifier)
        title = text
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "Back", imageName: "", action: #selector(didTapPopToRoot), menu: nil)
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "", imageName: "plus", action: #selector(didTapCreateNewValue), menu: nil)
    }
    
    private func setupSegmentControl(){
        segmentControl.selectedSegmentIndex = userDefaults.value(forKey: "selectedSegmentControl") as? Int ?? 1
        segmentControl.addTarget(self, action: #selector(handlerSegmentController), for: .valueChanged)
        handleRefreshControl()
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
        
        scrollView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
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

#Preview {
    return FFUserDetailCartesianChartViewController(typeIdentifier: .activeEnergyBurned)
}
