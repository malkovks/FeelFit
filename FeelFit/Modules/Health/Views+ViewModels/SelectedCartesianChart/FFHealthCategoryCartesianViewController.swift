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
    
    private var identifier: HKQuantityTypeIdentifier
    
    init(typeIdentifier: HKQuantityTypeIdentifier){
        self.identifier = typeIdentifier
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var chartDataProvider = [FFUserHealthDataProvider]()
    
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
        viewModel.pullToRefreshControl()

        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) { [weak self] in
            self?.scrollView.refreshControl?.endRefreshing()
            self?.updateChartDataSeries()
        }
    }
    
    @objc private func didTapPopToViewController(){
        viewModel.didTapPopToViewController()
    }

    @objc private func handlerSegmentController(_ sender: UISegmentedControl){
        viewModel.loadSelectedSegmentIndex(sender.selectedSegmentIndex)
        DispatchQueue.main.async {
            self.updateChartDataSeries()
        }
    }
    
    @objc private func didTapAddNewValue(){
        viewModel.didTapAddNewValue()
        DispatchQueue.main.async {
            self.updateChartDataSeries()
        }
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
        viewModel.loadSelectedSegmentIndex(currentIndex)
        DispatchQueue.main.async {
            self.updateChartDataSeries()
        }
    }
    //
    func didTapCallMenu() -> UIMenu {
        let identifiers: [HKQuantityTypeIdentifier] = FFHealthData.favouriteQuantityTypeIdentifier
        let data: [String] = FFHealthData.favouriteQuantityTypeIdentifier.map { getDataTypeName($0) }
        var items = [UIAction]()
        data.enumerated().forEach { (index,text) in
            items.append( UIAction(title: text) { [weak self] _ in
                self?.identifier = identifiers[index]
                self?.setupView()
            })
        }
        var menu: UIMenu {
            return UIMenu(title: "Selected health category", image: UIImage(systemName: "heart.fill"),children: items)
        }
        
        return menu
    }
    //MARK: - Setup Methods. This mark is done
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

    
    private func setupChartView(){
        chartView.delegate = self
        chartView.isUserInteractionEnabled = true
        chartView.graphView.isUserInteractionEnabled = true
        guard let data = viewModel.getAccessToFilterData(viewModel.selectedSegmentIndex) else { return }
        viewModel.loadSelectedCategoryData(filter: data)
        DispatchQueue.main.async {
            self.updateChartDataSeries()
        }
        
    }
    
    //complete
    private func updateChartDataSeries(){
        let data = viewModel.getValueData()
        DispatchQueue.main.async { [weak self] in
            self?.chartView.graphView.dataSeries = data.series
            self?.chartView.headerView.titleLabel.text = data.headerViewTitleLabel
            self?.chartView.headerView.detailLabel.text = data.headerViewDetailLabel
            self?.chartView.graphView.horizontalAxisMarkers = data.graphViewAxisMarkers
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
        button.menu = didTapCallMenu()
        button.showsMenuAsPrimaryAction = true
        
        navigationItem.titleView = button
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "Back", imageName: "", action: #selector(didTapPopToViewController), menu: nil)
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "", imageName: "plus", action: #selector(didTapAddNewValue), menu: nil)
    }
    
    private func setupSegmentControl(){
        segmentControl.selectedSegmentIndex = viewModel.selectedSegmentIndex
        segmentControl.addTarget(self, action: #selector(handlerSegmentController), for: .valueChanged)
        handleRefreshControl()
    }
    
    func setupViewModel() {
        viewModel = FFHealthCategoryCartesianViewModel(viewController: self, selectedCategoryIdentifier: identifier)
    }
}

extension FFHealthCategoryCartesianViewController: OCKChartViewDelegate {
    func didSelectChartView(_ chartView: UIView & CareKitUI.OCKChartDisplayable) {
        guard let chart = chartView as? OCKCartesianChartView else { return }
        let index = chart.graphView.selectedIndex!
        let data = viewModel.chartDataProvider[index]
        let valueString = String(describing: data.value) + " "
        let valueType = getUnitMeasurement(data.typeIdentifier!)
        alertError(message: valueString + valueType)
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
