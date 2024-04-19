//
//  FFHealthCategoryCartesianViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.02.2024.
//

import UIKit
import CareKit
import HealthKit


/// Class displaying selected identifier,add access to add data to healthStore for user and change periods of displaying data
class FFHealthCategoryCartesianViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFHealthCategoryCartesianViewModel!
    
    private let identifier: HKQuantityTypeIdentifier
    
    init(typeIdentifier: HKQuantityTypeIdentifier){
        self.identifier = typeIdentifier
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var chartDataProvider = [FFUserHealthDataProvider]()
    private var selectedSegmentIndex = UserDefaults.standard.value(forKey: "selectedSegmentControl") as? Int ?? 1
    
    private let userDefaults = UserDefaults.standard
    private let loadUserHealth = FFHealthDataManager.shared
    
    //MARK: - UI elements
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
        chart.applyConfiguration()
        chart.backgroundColor = .systemBackground
        chart.layer.borderWidth = 0.3
        chart.layer.borderColor = FFResources.Colors.darkPurple.cgColor
        chart.headerView.iconImageView?.image = UIImage(systemName: "heart")
        return chart
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = FFResources.Colors.activeColor
        return indicator
    }()
    
    //MARK: - display result
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    //MARK: - Actions
    @objc private func handleRefreshControl(){
        let data = getAccessToFilterData(sender: nil)
        loadUserData(filter: data)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    //TODO: Донастроить сегменты и отображение корректного текста в графиках
    @objc private func handlerSegmentController(_ sender: UISegmentedControl){
        loadSelectedIndexData(selectedIndex: sender.selectedSegmentIndex)
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
    
    func loadSelectedIndexData(selectedIndex: Int){
        let value = getAccessToFilterData(sender: selectedIndex)
        loadUserData(filter: value)
        userDefaults.set(selectedIndex, forKey: "selectedSegmentControl")
        selectedSegmentIndex = selectedIndex
    }
    
    @objc func didTapSwipeGestureRecognize(_ gesture: UISwipeGestureRecognizer){
        var currentIndex = segmentControl.selectedSegmentIndex
        
        if gesture.direction == .left {
            currentIndex += 1
        } else if gesture.direction == .right {
            currentIndex -= 1
        }
        
        if currentIndex < 0 {
            currentIndex = 0
        } else if currentIndex >= segmentControl.numberOfSegments {
            currentIndex = segmentControl.numberOfSegments - 1
        }
        
        segmentControl.selectedSegmentIndex = currentIndex
        loadSelectedIndexData(selectedIndex: currentIndex)
    }
    
    @objc func didTapChangeIdentifier(_ button: UIButton){
        let data: [String] = FFHealthData.favouriteQuantityTypeIdentifier.map { $0.rawValue }
        let menu = UIMenu(title: "Select displaying data",children: data.compactMap({ text in
            UIAction(title: text) { _ in
                print("Selected \(text)")
            }
        }))
        
        
    }
    
    func setupMenu() -> UIMenu {
        let data: [String] = FFHealthData.favouriteQuantityTypeIdentifier.map { getDataTypeName($0) }
        var items = [UIAction]()
        data.forEach { text in
            items.append( UIAction(title: text) { _ in
                print("Selected \(text)")
            })
        }
        var menu: UIMenu {
            return UIMenu(title: "Selected health category", image: UIImage(systemName: "heart.fill"),children: items)
        }
        
        return menu
    }
    //MARK: - Setup Methods
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupViewModel()
        setupSegmentControl()
        setupNavigationController()
        setupScrollView()
        setupChartView()
        setupGestures()
        setupConstraints()
    }
    
    func getAccessToFilterData(sender: Int?) -> SelectedTimePeriodData{
        let selectedCase = SelectedTimePeriodType(rawValue: sender ?? selectedSegmentIndex)
        let value = selectedCase.handlerSelectedTimePeriod()
        return value
    }
    
    private func setupChartView(){
        chartView.delegate = self
        chartView.isUserInteractionEnabled = true
        chartView.graphView.isUserInteractionEnabled = true
        let data = getAccessToFilterData(sender: nil)
        loadUserData(filter: data)
    }
    
    private func loadUserData(filter: SelectedTimePeriodData){
        viewModel.loadSelectedCategoryData(filter: filter) { model in
            guard let model = model else { return }
            self.chartDataProvider = model
            self.updateChartDataSeries(filter: filter)
        }
    }
    
    private func updateChartDataSeries(filter: SelectedTimePeriodData?){
        let chartTitle = getDataTypeName(identifier)
        let detailTextLabel = filter?.headerDetailText ?? createChartWeeklyDateRangeLabel(startDate: nil)
        let axisHorizontalMarkers = filter?.horizontalAxisMarkers ?? createHorizontalAxisMarkers()
        
        let measurementUnitText = getUnitMeasurement(identifier)
        
        let value: [CGFloat] = chartDataProvider.map { CGFloat($0.value) }
        let size = filter?.barSize ?? 5.0
        
        let series = OCKDataSeries(values: value, title: measurementUnitText.capitalized ,size: size, color: FFResources.Colors.activeColor)
        
        
        
        DispatchQueue.main.async { [weak self] in
            self?.chartView.graphView.dataSeries = [series]
            self?.chartView.headerView.titleLabel.text = chartTitle
            self?.chartView.headerView.detailLabel.text = detailTextLabel
            self?.chartView.graphView.horizontalAxisMarkers = axisHorizontalMarkers
        }
    }
    
    private func setupGestures(){
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didTapSwipeGestureRecognize))
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didTapSwipeGestureRecognize))
        rightSwipeGesture.direction = .right
        leftSwipeGesture.direction = .left
        scrollView.addGestureRecognizer(rightSwipeGesture)
        scrollView.addGestureRecognizer(leftSwipeGesture)
        
        scrollView.panGestureRecognizer.require(toFail: rightSwipeGesture)
        scrollView.panGestureRecognizer.require(toFail: leftSwipeGesture)
    }
    

    
    private func setupScrollView(){
        scrollView.refreshControl = refreshControl
        scrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    func setupNavigationController() {
        let button = UIButton(type: .custom)
        button.configuration = .borderless()
        button.configuration?.title = "Data type"
        button.configuration?.image = UIImage(systemName: "chevron.down")
        button.configuration?.imagePlacement = .trailing
        button.menu = setupMenu()
        button.showsMenuAsPrimaryAction = true
        
        navigationItem.titleView = button
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "Back", imageName: "", action: #selector(didTapPopToRoot), menu: nil)
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "", imageName: "plus", action: #selector(didTapCreateNewValue), menu: nil)
    }
    
    private func setupSegmentControl(){
        segmentControl.selectedSegmentIndex = userDefaults.value(forKey: "selectedSegmentControl") as? Int ?? 1
        segmentControl.addTarget(self, action: #selector(handlerSegmentController), for: .valueChanged)
        handleRefreshControl()
    }
    
    func setupViewModel() {
        viewModel = FFHealthCategoryCartesianViewModel(viewController: self, selectedCategoryIdentifier: identifier)
    }
}

private extension FFHealthCategoryCartesianViewController {
    func didAddNewData(with value: Double) {
        guard let sample = FFHealthDataProcess.processHealthSample(with: value, data: chartDataProvider) else { return }
        FFHealthData.saveHealthData([sample]) { [weak self] success, error in
            if let error = error {
                self?.alertError(title: "Error adding data to Health",message: error.localizedDescription)
            }
            if success {
                self?.handleRefreshControl()
            }
        }
    }
}

extension FFHealthCategoryCartesianViewController: OCKChartViewDelegate {
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

private extension FFHealthCategoryCartesianViewController {
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
    let nav = FFNavigationController(rootViewController: FFHealthCategoryCartesianViewController(typeIdentifier: .stepCount))
    return nav
}
