//
//  FFSubtitleTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 20.02.2024.
//

import UIKit

class FFSubtitleTableViewCell: UITableViewCell {
    
    static let identifier = "FFSubtitleTableViewCell"
    
    let firstTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.font = UIFont.textLabelFont(size: 16,weight: .heavy)
        label.textAlignment = .left
        return label
    }()
    
    var tableViewData: [[String]] = [
        ["Name","Second Name"],
        ["Birthday","Gender","Blood Type","Skin Type(Fitzpatrick Type)","Stoller chair"],
    ]
    
    let titleTextField: UITextField = {
        let field = UITextField(frame: .zero)
        field.textAlignment = .right
        field.font = UIFont.textLabelFont(size: 16,weight: .regular)
        field.placeholder = "Enter value"
        field.backgroundColor = .clear
        field.textColor = .main
        field.isUserInteractionEnabled = true
        field.isEnabled = false
        return field
    }()
    
    let subtitleResultLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = UIFont.textLabelFont(size: 16, for: .body, weight: .regular)
        label.textColor = .customBlack
        label.isHidden = true
        return label
    }()
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 2
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellConstraints()
        setupContentView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleTextField.text = nil
        firstTitleLabel.text = nil
        subtitleResultLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabels(value: [[String]], indexPath: IndexPath){
        let text = value[indexPath.section][indexPath.row]
        let mainText = tableViewData[indexPath.section][indexPath.row]
        setupConfiguration(indexPath, titleLabel: mainText, info: text)
    }
    
    func configureView(userDictionary data: [[String:String]],_ indexPath: IndexPath){
        let dictionary = data[indexPath.section]
        let key: String = Array(dictionary.keys).sorted()[indexPath.row]
        let value: String = dictionary[key] ?? ""
        
        
        setupConfiguration(indexPath,titleLabel: key,info: value)
    }
    
    func setupConfiguration(_ indexPath: IndexPath,titleLabel: String, info: String?){
        firstTitleLabel.text = titleLabel
        switch indexPath.section {
        case 0:
            firstTitleLabel.text = titleLabel
            titleTextField.text = info
            titleTextField.isHidden = false
            subtitleResultLabel.isHidden = true
        case 1:
            titleTextField.isHidden = true
            subtitleResultLabel.isHidden = false
            subtitleResultLabel.text = info
            subtitleResultLabel.textColor = .main
        default:
            titleTextField.text = nil
            subtitleResultLabel.text = nil
            firstTitleLabel.text = nil
            break
        }
    }
    
    func configureEditingCell(_ isEditing: Bool){
        if isEditing {
            titleTextField.isUserInteractionEnabled = true
            titleTextField.isHidden = false
            titleTextField.isEnabled = true
            titleTextField.textColor = FFResources.Colors.activeColor
        } else {
            titleTextField.isUserInteractionEnabled = false
            titleTextField.isEnabled = false
            titleTextField.textColor = FFResources.Colors.textColor
            titleTextField.resignFirstResponder()
            titleTextField.backgroundColor = .clear
        }
    }
    
    private func setupContentView(){
        self.backgroundColor = .systemBackground
        
    }
    
    private func setupCellConstraints(){
        stackView.addArrangedSubview(firstTitleLabel)
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(subtitleResultLabel)
        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
}
