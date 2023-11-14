//
//  FFCreateTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 14.11.2023.
//

import UIKit

class FFCreateTableViewCell: UITableViewCell {
    
    var viewModel: FFCreateProgramViewModel!

    static let identifier = "FFCreateTableViewCell"
    
    private let selectorButton: UIButton = {
       let button = UIButton()
        button.isHidden = false
        button.configuration = .borderedTinted()
        button.contentMode = .right
        button.configuration?.image = UIImage(systemName: "chevron.up.chevron.down")
        button.configuration?.imagePlacement = .trailing
        button.configuration?.titleAlignment = .leading
        button.configuration?.title = ""
        button.configuration?.imagePadding = 2
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = FFResources.Colors.activeColor
        return button
    }()
    
    private let nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter the name of workout"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.textColor = FFResources.Colors.textColor
        field.isHidden = true
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
        setupViewModel()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupCell(){
        backgroundColor = .systemBackground
    }
    
    private func setupViewModel(){
        viewModel = FFCreateProgramViewModel(viewController: FFCreateProgramViewController())
        selectorButton.menu = viewModel.pressSettingMenu()
        
    }
    
    func configureTableViewCell(tableView: UITableView,indexPath: IndexPath,text: [[String]]) {
        self.textLabel?.text = text[indexPath.section][indexPath.row]
        switch indexPath {
        case [0,0]: 
            self.textLabel?.text = nil
            selectorButton.isHidden = true
            nameTextField.isHidden = false
        case [1,0]:
            selectorButton.configuration?.title = "None"
        default:
            break
        }
    }
    
    
    private func setupConstraints(){
        contentView.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(selectorButton)
        selectorButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(2)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }

}
