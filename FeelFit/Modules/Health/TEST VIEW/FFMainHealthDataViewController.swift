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
    
    private let chartDataProvider: [FFUserHealthDataProvider]
    
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
        let titles = ["Day","Week","Month","Half Year","Year"]
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
    
    @objc private func didTapPopToRoot(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapPresentUserProfile(){
        let vc = FFHealthUserProfileViewController()
        present(vc, animated: true)
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
        guard let firstChartData = chartDataProvider.first,
              let identifier = firstChartData.typeIdentifier else {
            return
        }
        for n in chartDataProvider {
            dump(n.sources)
        }
        let chartTitle = getDataTypeName(identifier)
        chartView.headerView.titleLabel.text = chartTitle
        let measurementUnitText = getUnitMeasurement(identifier)
        
        let value: [CGFloat] = chartDataProvider.map { CGFloat($0.value) }
        
        let series = OCKDataSeries(values: value, title: measurementUnitText.capitalized ,size: 2, color: .systemIndigo)
        
        DispatchQueue.main.async {
            self.chartView.graphView.dataSeries = [series]
        }
    }
    
    private func loadChartViewData(type: FFHealthDateType){
        var value: DateComponents = DateComponents()
        switch type {
        case .day:
            value = DateComponents(day: 1)
        case .week:
            value = DateComponents(day: 7)
        case .month:
            value = DateComponents(day: 30)
        case .sixMonth,.year:
            value = DateComponents(month: 1)
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

extension FFMainHealthDataViewController: OCKChartViewDelegate {
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
