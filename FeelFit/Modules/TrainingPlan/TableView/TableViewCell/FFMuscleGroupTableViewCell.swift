//
//  FFMuscleGroupTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 04.12.2023.
//

import UIKit

class FFMuscleGroupTableViewCell: UITableViewCell {
    
    let mainTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.textLabelFont(size: 24)
        label.textColor = FFResources.Colors.textColor
        return label
    }()
    
    let muscleImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.tintColor = FFResources.Colors.activeColor
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0.5
        image.layer.borderColor = FFResources.Colors.textColor.cgColor
        image.image = UIImage(systemName: "figure.highintensity.intervaltraining")
        return image
    }()
    
    static let identifier = "FFMuscleGroupTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellConstraints()
        setupCell()
    }
    
    private func setupCell(){
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(indexPath: IndexPath, data: [String : String]){
        let key = Array(data.keys.sorted())[indexPath.row]
        let valueName = data[key]
        muscleImageView.image = UIImage(named: key) ?? UIImage(systemName: "figure.run")
        mainTextLabel.text = valueName
    }
    
    private func setupCellConstraints(){
        let height = contentView.snp.height
        
        contentView.addSubview(muscleImageView)
        muscleImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(3)
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(height).multipliedBy(0.9)
        }
        
        contentView.addSubview(mainTextLabel)
        mainTextLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(3)
            make.leading.equalTo(muscleImageView.snp.trailing).offset(2)
            make.trailing.equalToSuperview().inset(10)
        }
    }
}
