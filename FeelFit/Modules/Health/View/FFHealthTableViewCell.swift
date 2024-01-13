//
//  FFHealthTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 12.01.2024.
//

import UIKit
import HealthKit

class FFHealthTableViewCell: UITableViewCell {
    
    static let identifier = "FFHealthTableViewCell"
    
    private let firstLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.textLabelFont(size: 18,weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private let secondLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.textLabelFont(size: 16,weight: .thin)
        label.textAlignment = .right
        label.textColor = FFResources.Colors.detailTextColor
        return label
    }()
    
    private let stackView: UIStackView = UIStackView(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellConstraints()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ indexPath: IndexPath,_ identifier: String,_ model: [HealthModelValue]){
        let value = model[indexPath.row]
        let type: HKQuantityTypeIdentifier = HKQuantityTypeIdentifier(rawValue: identifier)
        var secondaryText: String = ""
        if type == .activeEnergyBurned {
            secondaryText = " kkal"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        guard let stepsString = formatter.string(from: NSNumber(value: value.value)) else { return }
        let dateString = DateFormatter.localizedString(from: value.date, dateStyle: .medium, timeStyle: .none)
        DispatchQueue.main.async { [unowned self] in
            firstLabel.text = stepsString + secondaryText
            secondLabel.text = dateString
        }
    }
    
    private func setupCell(){
        
    }
    
    private func setupCellConstraints(){
        stackView.addArrangedSubview(firstLabel)
        stackView.addArrangedSubview(secondLabel)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
