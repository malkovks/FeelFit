//
//  FFCreateTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 14.11.2023.
//

import UIKit

class FFCreateTableViewCell: UITableViewCell, UIEditMenuInteractionDelegate {
    
    var viewModel: FFCreateProgramViewModel!
    
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
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
        setupViewModel()
        setupContentView()
//        setupInteraction()
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
    
    func setupContentView(){
        
        self.textLabel?.font = UIFont.textLabelFont()
    }
    /*
    func setupInteraction(){
        self.addInteraction(UIEditMenuInteraction(delegate: self))
    }
    
    func editMenuInteraction(_ interaction: UIEditMenuInteraction, menuFor configuration: UIEditMenuConfiguration, suggestedActions: [UIMenuElement]) -> UIMenu? {
        
        let action = UIAction(title: "Action 1",image: UIImage(systemName: "circle")) { _ in
            print("Action 1")
        }
        let action2 = UIAction(title: "Action 2",image: UIImage(systemName: "trash")) { _ in
            print("Action 2")
        }
        var menu = UIMenu(title: "Editor", children: [action,action2])
        return menu
    }*/
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupCell(){
        backgroundColor = .systemBackground
    }
    
    private func setupViewModel(){
        viewModel = FFCreateProgramViewModel(viewController: FFCreateProgramViewController())
        viewModel.delegate = self
    }
    
    func configureSelectionCell(tableView: UITableView,indexPath: IndexPath){
        
    }
    
    func configureTableViewCell(tableView: UITableView,indexPath: IndexPath,text: [[String]],actionLabel string: [[String]]) {
        let text = text[indexPath.section][indexPath.row]
        let detailText = string[indexPath.section][indexPath.row]
        actionMenuLabel.attributedText = attributedTextForDetailLabel(string: detailText)
        self.textLabel?.text = text
        switch indexPath {
        case [0,0]:
            self.textLabel?.text = nil
            self.actionMenuLabel.isHidden = true
            nameTextField.isHidden = false
        case [1,0]:
            print("Index [1,0")
            self.actionMenuLabel.isHidden = false
        case [1,1]:
            print("Index [1,1")
            self.actionMenuLabel.isHidden = false
        case [1,2]:
            print("Index [1,2")
            self.actionMenuLabel.isHidden = false
        default:
            nameTextField.isHidden = true
        }
    }
}
extension FFCreateTableViewCell: ButtonMenuPressed {
    func menuDidSelected(text: String,_ indexPath: IndexPath) {
        switch indexPath {
        default:
            break
        }
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
