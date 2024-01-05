//
//  FFPlanCompletedTrainingTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 05.01.2024.
//

import UIKit

class FFPlanCompletedTrainingTableViewCell: UITableViewCell {
    static let identifier = "FFPlanCompletedTrainingTableViewCell"
    
    private let mainLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 20,weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.contentMode = .left
        label.textColor = FFResources.Colors.textColor
        return label
    }()
    
    private let firstDetailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16,weight: .thin)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = FFResources.Colors.textColor
        return label
    }()
    
    private let secondDetailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16,weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = FFResources.Colors.textColor
        return label
    }()
    
    private let stackView = UIStackView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell(){
        
    }
    
    private func setupCellConstraints(){
        contentView.addSubview(mainLabel)
        
        let elementSize = contentView.frame.height/2
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-2)
            make.leading.equalToSuperview().offset(2)
            make.height.equalTo(elementSize+2)
            make.width.equalToSuperview()
        }
    }
}
