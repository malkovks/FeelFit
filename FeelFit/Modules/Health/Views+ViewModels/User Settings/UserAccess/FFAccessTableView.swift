//
//  FFAccessTableView.swift
//  FeelFit
//
//  Created by Константин Малков on 13.05.2024.
//

import UIKit



class FFAccessTableViewCell : UITableViewCell {
    
    static let identifier = "FFAccessTableViewCell"
    
    private let switchButton: UISwitch = {
        let _switch = UISwitch(frame: .zero)
        _switch.onTintColor = .main
        _switch.isEnabled = true
        return _switch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellConstraints()
        setupSwitchButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapSwitch(_ sender: UISwitch){
        let switchTag = sender.tag
        let handler = IndexHandlerRequestAccess(caseValue: switchTag)
        if !sender.isOn {
            print("Sender become to off")
        } else {
            print("Request access to current index ")
            handler.processCaseValue()
        }
    }
    
    func configureCell(value: EnableServiceStatus,indexPath: IndexPath){
        switchButton.tag = indexPath.row
        switch indexPath.row {
        case 0: configureCell(value: value.notification, text: "User notification")
        case 1: configureCell(value: value.camera, text: "User access to camera")
        case 2: configureCell(value: value.media, text: "User access to media")
        case 3: configureCell(value: value.health, text: "User access to health")
        case 4: configureCell(value: value.userHealth, text: "User access to personal data")
        default: break
        }
    }
    
    
    
    private func setupSwitchButton(){
        switchButton.addTarget(self, action: #selector(didTapSwitch), for: .primaryActionTriggered)
    }
    
    
    
    private func configureCell(value: Bool, text: String?){
        self.textLabel?.text = text
        switchButton.setOn(value, animated: true)
    }
    
    private func setupCellConstraints(){
        contentView.addSubview(switchButton)
        switchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalToSuperview().dividedBy(2)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
}

class FFAccessHeaderTableView: UITableViewHeaderFooterView {
    static let identifier = "FFAccessHeaderTableView"

    private let headerText: String = "This page include current status of application services. If you want to change access to service you can toggle switch button"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeaderView(_ tableView: UITableView){
        textLabel?.frame = CGRect(x: 0, y: 5, width: tableView.frame.width, height: tableView.sectionHeaderHeight)
        textLabel?.text = headerText
        textLabel?.numberOfLines = 0
    }
}

class FFAccessFooterTableView: UITableViewHeaderFooterView {
    static let identifier = "FFAccessFooterTableView"
    
    private let footerText: String = NSLocalizedString("Important information. If you want to disable access to any service it is better to switch in Settings -> FeelFit -> Services which status you want to change.\nIf you have disabled access to the service and need to re-enable it, you will need to do it manually back in the system settings and change access.", comment: "comment")
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureFooterView(_ tableView: UITableView){
        textLabel?.text = footerText
        textLabel?.frame = CGRect(x: 0, y: 5, width: tableView.frame.width, height: tableView.sectionFooterHeight)
    }
    
}
