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
        label.contentMode = .left
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.detailLabelFont(size: 18,weight: .thin)
        label.numberOfLines = 0
        label.contentMode = .left
        label.textAlignment = .left
        label.text = "Default"
        label.sizeToFit()
        label.isHidden = true
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    let infoTextField: UITextField = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        label.text = "Title: "
        label.font = UIFont.headerFont(size: 16)
        label.textAlignment = .left
        
        let field = UITextField(frame: .zero)
        field.returnKeyType = .continue
        field.tintColor = .systemBlue
        field.isEnabled = false
        field.font = UIFont.textLabelFont(size: 16, weight: .thin)
        field.placeholder = "Enter the name of training"
        field.leftView = label
        field.leftViewMode = .always
        field.clearButtonMode = .whileEditing
        field.borderStyle = .none
        field.isEnabled = false
        field.textColor = FFResources.Colors.textColor
        field.backgroundColor = .clear
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isHidden = true
        return field
    }()
    
    
    let switchButton: UISwitch = {
        let switchButton = UISwitch(frame: .zero)
        switchButton.tintColor = FFResources.Colors.activeColor
        switchButton.isOn = false
        switchButton.onTintColor = FFResources.Colors.activeColor
        switchButton.preferredStyle = .sliding
        switchButton.isHidden = true
        switchButton.isEnabled = false
        return switchButton
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.sizeToFit()
        stackView.distribution = .fill
        return stackView
    }()

    var textViewData = String()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ data: FFTrainingPlanRealmModel,indexPath: IndexPath,_ isTableViewEditing: Bool){
        checkTableView(isEditing: isTableViewEditing, indexPath: indexPath)
        
        
        let value: [String] = data.trainingExercises.map { values -> String in
            let text = values.exerciseName
            return text
        }
        let date = DateFormatter.localizedString(from: data.trainingDate, dateStyle: .short, timeStyle: .short)
        let textString = value.joined(separator: ";\n-")
        
        switch indexPath{
        case .init(row: 0, section: 0):
            infoTextField.text = data.trainingName
            infoTextField.isHidden = false
            infoTextField.isEnabled = false
            infoTextField.backgroundColor = .clear
            infoTextField.borderStyle = .none
            stackView.addArrangedSubview(infoTextField)
        case .init(row: 1, section: 0):
            mainLabel.text = "Note :"
            infoLabel.text = data.trainingNotes
            infoLabel.isHidden = false
            stackView.axis = .vertical
            stackView.addArrangedSubview(mainLabel)
            stackView.addArrangedSubview(infoLabel)
        case .init(row: 2, section: 0):
            mainLabel.text = "Date :"
            infoLabel.text = date
            infoTextField.isHidden = true
            infoLabel.isHidden = false
            stackView.addArrangedSubview(mainLabel)
            stackView.addArrangedSubview(infoLabel)
        case .init(row: 3, section: 0):
            mainLabel.text = "Type :"
            infoLabel.text = data.trainingType ?? "Default"
            infoLabel.isHidden = false
            infoTextField.isHidden = true
            stackView.addArrangedSubview(mainLabel)
            stackView.addArrangedSubview(infoLabel)
        case .init(row: 4, section: 0):
            mainLabel.text = "Location :"
            infoLabel.text = data.trainingLocation ?? "Default"
            infoLabel.isHidden = false
            infoTextField.isHidden = true
            stackView.addArrangedSubview(mainLabel)
            stackView.addArrangedSubview(infoLabel)
        case .init(row: 5, section: 0):
            mainLabel.text = "Notification status:"
            switchButton.isOn = data.trainingNotificationStatus
            switchButton.isEnabled = false
            infoLabel.isHidden = true
            infoTextField.isHidden = true
            switchButton.isHidden = false
            stackView.addArrangedSubview(mainLabel)
        case .init(row: 6, section: 0):
            mainLabel.text = "Exercise name: "
            infoLabel.text = "-" + textString + " ."
            infoTextField.isHidden = true
            infoLabel.isHidden = false
            stackView.addArrangedSubview(mainLabel)
            stackView.addArrangedSubview(infoLabel)
            stackView.axis = .vertical
        default:
            break
        }
    }
    
    private func checkTableView(isEditing: Bool,indexPath: IndexPath){
            infoTextField.isEnabled = true
            infoTextField.borderStyle = .roundedRect
            infoTextField.backgroundColor = FFResources.Colors.backgroundColor
            
            switchButton.isEnabled = true
    }
    
    private func setupCell(){
        self.backgroundColor = .systemBackground
        self.contentMode = .bottomLeft
        self.accessoryView = .none
    }

    
    private func setupConstraints(){
        
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        contentView.addSubview(switchButton)
        switchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
    }

}
