//
//  FFPresentHealthCollectionViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 05.02.2024.
//

import UIKit
import CareKit

class FFPresentHealthCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FFPresentHealthCollectionViewCell"
    
    //label + button 1 stackView
    private let titleHeaderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.textLabelFont(size: 20)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let dataDetailPresentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.configuration = .filled()
        button.configuration?.title = "Data title"
        button.configuration?.image = UIImage(systemName: "chevron.right")
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .trailing
        button.configuration?.baseForegroundColor = FFResources.Colors.detailTextColor
        button.configuration?.baseBackgroundColor = FFResources.Colors.detailTextColor
        return button
    }()
    
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
        label.font = UIFont.detailLabelFont(size: 15)
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
        setupConstraints()
    }
    
    func configureCell(){
        
    }
    
    private func setupCellView(){
        backgroundColor = .systemRed
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    private func setupConstraints(){
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
