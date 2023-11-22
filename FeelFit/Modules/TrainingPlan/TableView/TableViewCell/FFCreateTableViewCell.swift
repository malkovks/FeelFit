//
//  FFCreateTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 14.11.2023.
//

import UIKit

class FFCreateTableViewCell: UITableViewCell, UIEditMenuInteractionDelegate {
    
    
    static let identifier = "FFCreateTableViewCell"
    
    private let actionMenuLabel: UILabel = {
       let label = UILabel()
        label.textColor = FFResources.Colors.detailTextColor
        label.font = UIFont.detailLabelFont(size: 14)
        label.backgroundColor = .clear
        label.textAlignment = .right
        return label
    }()
    
    private let nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter the name of workout"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.textColor = FFResources.Colors.textColor
        field.isHidden = true
        field.clearButtonMode = .always
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Action methods
    
    //MARK: -Setup
    private func setupContentView(){
        self.textLabel?.font = UIFont.textLabelFont()
    }

    private func setupCell(){
        backgroundColor = .systemBackground
    }
    
    //MARK: - Initialized methods
    func configureTableViewCell(tableView: UITableView,indexPath: IndexPath,text: [[String]],actionLabel string: [[String]]) {
        let text = text[indexPath.section][indexPath.row]
        let detailText = string[indexPath.section][indexPath.row]
        actionMenuLabel.attributedText = attributedTextForDetailLabel(string: detailText)
        self.textLabel?.text = text
        switch indexPath {
        case [0,0]:
            self.textLabel?.text = nil
            nameTextField.isHidden = false
            self.actionMenuLabel.isHidden = true
        default:
            nameTextField.isHidden = true
            self.actionMenuLabel.isHidden = false
            break
        }
    }
    
    func attributedTextForDetailLabel(string: String) -> NSAttributedString{
        let image = NSTextAttachment()
        image.image = UIImage(systemName: "chevron.up.chevron.down")
        let imageString = NSAttributedString(attachment: image)
        
        let textString = NSAttributedString(string: string)
        let combination = NSMutableAttributedString()
        
        combination.append(textString)
        combination.append(NSAttributedString(string: " "))
        combination.append(imageString)
        return combination
    }
}
 
extension FFCreateTableViewCell {
    private func setupConstraints(){
        contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(actionMenuLabel)
        actionMenuLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(2)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
    }
}
