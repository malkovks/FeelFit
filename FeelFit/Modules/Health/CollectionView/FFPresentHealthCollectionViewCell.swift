//
//  FFPresentHealthCollectionViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 05.02.2024.
//

import UIKit
import CareKit
import HealthKit

class FFPresentHealthCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FFPresentHealthCollectionViewCell"
    
    //label + button 1 stackView
    private let titleStackView = UIStackView(frame: .zero)
    
    private let titleHeaderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.textLabelFont(size: 20,weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let dataDetailPresentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.configuration = .tinted()
        button.configuration?.image = UIImage(systemName: "chevron.right")
        button.configuration?.imagePadding = 5
        button.configuration?.imagePlacement = .trailing
        button.configuration?.baseForegroundColor = FFResources.Colors.detailTextColor
        button.configuration?.baseBackgroundColor = .clear
        return button
    }()
    
    private let valueStackView = UIStackView(frame: .zero)
    
    //value label + type value label 2 stackView
    private let valueResultLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.headerFont(size: 30)
        label.numberOfLines = 1
        label.textColor = FFResources.Colors.textColor
        label.textAlignment = .left
        return label
    }()
    
    private let valueTypeDataLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.detailLabelFont(size: 15,weight: .thin)
        label.numberOfLines = 1
        label.textColor = FFResources.Colors.detailTextColor
        label.textAlignment = .left
        return label
    }()
    
    private let basicGraphView: OCKCartesianChartView = {
        let chart = OCKCartesianChartView(type: .bar)
        return chart
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellView()
        setupStackView()
        setupConstraints()
    }
    
    func configureCell(_ indexPath: IndexPath, values: [FFUserHealthDataProvider]){
        guard let data = values.last else { return }
        let quantityId = HKQuantityTypeIdentifier(rawValue: data.identifier)
        let valueResult = data.value
        let valueType = getUnitMeasurement(quantityId).capitalized
        let titleHeaderText = getDataTypeName(quantityId)
        
        DispatchQueue.main.async { [weak self] in
            self?.titleHeaderLabel.text = titleHeaderText
            self?.valueResultLabel.text = String(describing: Int(valueResult))
            self?.valueTypeDataLabel.text = valueType
        }
    }
    
    private func setupCellView(){
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    private func setupStackView(){
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill
        titleStackView.spacing = 5
        titleStackView.alignment = .fill
        
        valueStackView.axis = .vertical
        valueStackView.distribution = .fill
        valueStackView.alignment = .leading
        valueStackView.spacing = 1
    }
    
    private func setupConstraints(){
        titleStackView.addArrangedSubview(titleHeaderLabel)
        titleStackView.addArrangedSubview(dataDetailPresentButton)
        
        contentView.addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.trailing.equalToSuperview().inset(2)
            make.height.equalTo(contentView.frame.height/5)
        }
        
        valueStackView.addArrangedSubview(valueResultLabel)
        valueStackView.addArrangedSubview(valueTypeDataLabel)
        
        contentView.addSubview(valueStackView)
        valueStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(5)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
