//
//  FFSubtitleTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 20.02.2024.
//

import UIKit

class FFSubtitleTableViewCell: UITableViewCell {
    
    static let identifier = "FFSubtitleTableViewCell"
    
    private let firstTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.font = UIFont.textLabelFont(size: 16,weight: .thin)
        label.textAlignment = .left
        label.textColor =  FFResources.Colors.textColor
        return label
    }()
    
    private let titleTextField: UITextField = {
        let field = UITextField(frame: .zero)
        field.textAlignment = .right
        field.font = UIFont.textLabelFont(size: 16,weight: .regular)
        field.placeholder = "Not detected"
        field.backgroundColor = .clear
        field.textColor = FFResources.Colors.textColor
        field.isUserInteractionEnabled = false
        field.isEnabled = false
        
        return field
    }()
    
    private let pickerTargetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.configuration = .tinted()
        button.configuration?.titleAlignment = .trailing
        button.configuration?.imagePlacement = .leading
        button.configuration?.imagePadding = 2
        button.configuration?.baseBackgroundColor = .lightGray
        button.configuration?.title = "Some text"
        button.configuration?.baseForegroundColor = FFResources.Colors.customBlack
        button.isHidden = true
        return button
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(userDictionary data: [[String:String]],_ indexPath: IndexPath){
        let dictionary = data[indexPath.section]
        let key: String = Array(dictionary.keys).sorted()[indexPath.row]
        let value: String = Array(dictionary.values).sorted()[indexPath.row]
        
        
//        setupConfiguration(indexPath)
        setupInformation(title: key, info: value)
    }
    
    func setupConfiguration(_ indexPath: IndexPath){
        switch indexPath.section {
        case 0:
            configureEditingCell(true)
        case 1,2:
            let text = titleTextField.text
            titleTextField.isHidden = false
            pickerTargetButton.isHidden = false
            pickerTargetButton.configuration?.title = text
            configureEditingCell(false)
        default:
            break
        }
        
    }
    
    enum TableViewCellValue {
        case textField
        case picker
    }
    
    private func setupInformation(title: String, info: String?){
        firstTitleLabel.text = title
        if info == "Not set"{
            titleTextField.textColor = .lightGray
        }
        titleTextField.text = info
    }
    
    func configureEditingCell(_ isEditing: Bool){
        if isEditing {
            titleTextField.isUserInteractionEnabled = true
            titleTextField.isHidden = false
            titleTextField.isEnabled = true
            titleTextField.textColor = FFResources.Colors.activeColor
            titleTextField.backgroundColor = .secondarySystemBackground
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
        stackView.addArrangedSubview(pickerTargetButton)
        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
}
