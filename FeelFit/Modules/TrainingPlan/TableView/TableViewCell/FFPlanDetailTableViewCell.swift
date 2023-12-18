//
//  FFPlanDetailTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 18.12.2023.
//

import UIKit

class FFPlanDetailTableViewCell: UITableViewCell {
    
    static let identifier = "FFPlanDetailTableViewCell"
    
    let mainLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.headerFont(size: 20)
        label.numberOfLines = 0
        label.textColor = FFResources.Colors.textColor
        label.textAlignment = .left
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.detailLabelFont(size: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let switchButton: UISwitch = {
        let switchButton = UISwitch(frame: .zero)
        switchButton.tintColor = FFResources.Colors.activeColor
        switchButton.isOn = false
        switchButton.onTintColor = FFResources.Colors.activeColor
        switchButton.preferredStyle = .checkbox
        switchButton.isHidden = true
        return switchButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCell(_ data: FFTrainingPlanRealmModel,indexPath: IndexPath){
        switch indexPath.row {
        case 0:
            mainLabel.text = "Name :"
            infoLabel.text = data.trainingName
        case 1:
            mainLabel.text = "Note :"
            infoLabel.text = data.trainingNotes
        case 2:
            mainLabel.text = "Date :"
            infoLabel.text = DateFormatter.localizedString(from: data.trainingDate, dateStyle: .medium, timeStyle: .short)
        case 3:
            mainLabel.text = "Type :"
            infoLabel.text = data.trainingType ?? "Default"
        case 4:
            mainLabel.text = "Location :"
            infoLabel.text = data.trainingLocation ?? "Default"
        case 5:
            mainLabel.text = "Notification status:"
            switchButton.isHidden = false
            switchButton.isOn = data.trainingNotificationStatus
        case (6 + data.trainingExercises.count):
            mainLabel.text = "Exercise name: "
            for exercise in data.trainingExercises {
                infoLabel.text = exercise.exerciseName
            }
        default:
            switchButton.isHidden = true
        }
    }
    
    private func setupCell(){
        
    }

    
    private func setupConstraints(){
        let stackView = UIStackView(arrangedSubviews: [mainLabel, infoLabel])
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillProportionally
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        contentView.addSubview(switchButton)
        switchButton.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.trailing).offset(-5)
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }

}
