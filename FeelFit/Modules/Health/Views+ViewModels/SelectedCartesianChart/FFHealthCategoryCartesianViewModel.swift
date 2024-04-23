//
//  FFHealthCategoryCartesianViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 16.04.2024.
//

import UIKit
import CareKit
import HealthKit

protocol HealthCartesianDelegate: AnyObject {
    func didLoadData()
}

protocol HealthCartesianViewModelProtocol: AnyObject {
    var delegate: HealthCartesianDelegate? { get set }
    func loadData(selectedIndex: Int?)
    func getChartViewData() -> ChartData
}

class FFHealthCategoryCartesianViewModel: HealthCartesianViewModelProtocol {
    
    weak var delegate: HealthCartesianDelegate?
    
    private let userDefaults = UserDefaults.standard
    private let viewController: UIViewController
    private let selectedCategoryIdentifier: HKQuantityTypeIdentifier
    
    var selectedSegmentIndex = UserDefaults.standard.value(forKey: "selectedSegmentControl") as? Int ?? 1
    var chartDataProvider = [FFUserHealthDataProvider]()
    
    init(viewController: UIViewController, selectedCategoryIdentifier: HKQuantityTypeIdentifier) {
        self.viewController = viewController
        self.selectedCategoryIdentifier = selectedCategoryIdentifier
    }
    
    @objc func didTapAddNewValue(){
        let title = getDataTypeName(self.selectedCategoryIdentifier)
        
        let message = "Enter a value to add a sample to your health data."
        
        viewController.presentTextFieldAlertController(placeholder: title, keyboardType: .numberPad, alertTitle: title,message: message) { [weak self] text in
            guard let doubleValue = Double(text) else { return }
            self?.didTapAddNewValueToHealthStore(with: doubleValue)
        }
    }
    
    @objc func didTapPopToViewController(){
        viewController.navigationController?.popViewController(animated: true)
    }
    
    //load data by selected index or by last used selected index in segment control
    func loadData(selectedIndex: Int? = nil){
        let index = selectedIndex ?? selectedSegmentIndex
        selectedSegmentIndex = index
        userDefaults.set(index, forKey: "selectedSegmentControl")
        guard let filter = getAccessToFilterData(index) else { return }
        loadSelectedCategoryData(filter: filter)
        delegate?.didLoadData()
    }
    
    
    /// Convert loaded data and return completed data for display in chart
    func getChartViewData() -> ChartData {
        let filter = getAccessToFilterData(selectedSegmentIndex)
        let chartTitle = getDataTypeName(selectedCategoryIdentifier)
        let detailTextLabel = filter?.headerDetailText ?? createChartWeeklyDateRangeLabel(startDate: nil)
        let axisHorizontalMarkers = filter?.horizontalAxisMarkers ?? createHorizontalAxisMarkers()
        
        let measurementUnitText = getUnitMeasurement(selectedCategoryIdentifier)
        
        let value: [CGFloat] = chartDataProvider.map { CGFloat($0.value) }
        let size = filter?.barSize ?? 5.0
        
        let series = OCKDataSeries(values: value, title: measurementUnitText.capitalized ,size: size, color: FFResources.Colors.activeColor)
        return ChartData(series: [series], headerViewTitleLabel: chartTitle, headerViewDetailLabel: detailTextLabel, graphViewAxisMarkers: axisHorizontalMarkers)
    }
    
    private func didTapAddNewValueToHealthStore(with value: Double) {
        guard let sample = FFHealthData.processHealthSample(with: value, data: chartDataProvider) else { return }
        FFHealthData.saveHealthData([sample]) { [weak self] success, error in
            if let error = error {
                self?.viewController.alertError(title: "Error adding data to Health",message: error.localizedDescription)
            }
            if success {
                self?.loadData()
                self?.delegate?.didLoadData()
            }
        }
    }
    
    private func loadSelectedCategoryData(filter: SelectedTimePeriodData){
        let start = Calendar.current.date(byAdding: DateComponents(day: -6), to: Date())!
        let startDate = Calendar.current.startOfDay(for: start)
        
        FFHealthDataManager.shared.loadSelectedIdentifierData(filter: filter, identifier: selectedCategoryIdentifier, startDate: startDate) { [weak self] model in
            guard let model = model else { return }
            self?.chartDataProvider = model
            self?.delegate?.didLoadData()
        }
    }
    

    
    private func getAccessToFilterData(_ sender: Int?) -> SelectedTimePeriodData? {
        let _case = SelectedTimePeriodType(rawValue: sender ?? selectedSegmentIndex)
        let value = _case.handlerSelectedTimePeriod()
        return value
    }
}






