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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellConstraints()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(title: String,textFieldText: String?){
        firstTitleLabel.text = title
        if textFieldText == "Not set"{
            titleTextField.textColor = .lightGray
        }
        titleTextField.text = textFieldText
    }
    
    func configureEditingCell(_ isEditing: Bool){
        if isEditing {
            titleTextField.isUserInteractionEnabled = true
            titleTextField.isEnabled = true
            titleTextField.textColor = FFResources.Colors.activeColor
        } else {
            titleTextField.isUserInteractionEnabled = false
            titleTextField.isEnabled = false
            titleTextField.textColor = FFResources.Colors.textColor
            titleTextField.resignFirstResponder()
        }
    }
    
    private func setupContentView(){
        self.backgroundColor = .systemBackground
        
    }
    
    private func setupCellConstraints(){
        let stackView = UIStackView(arrangedSubviews: [firstTitleLabel,titleTextField])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 2
        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
}
