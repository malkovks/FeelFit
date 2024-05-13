//
//  FFAccessTableViewCell.swift
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
        if !sender.isOn {
            print("Sender become to off")
        } else {
            SwitchSetupHandler(caseValue: switchTag)
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

class SwitchSetupHandler {
    
    let caseValue: Int
    
    init(caseValue: Int){
        self.caseValue = caseValue
        processCaseValue()
    }
    
    private func processCaseValue(){
        switch caseValue {
        case 0: requestAccessToNotification()
        case 1: requestAccessToCamera()
        case 2: requestAccessToMedia()
        case 3: requestAccessToHealth()
        case 4: requestAccessToUserHealth()
        default: break
        }
    }
    
    private func requestAccessToNotification(){
        print("requestAccessToNotification")
    }
    
    private func requestAccessToCamera(){
        print("requestAccessToCamera")
    }
    
    private func requestAccessToMedia(){
        print("requestAccessToMedia")
    }
    
    private func requestAccessToHealth(){
        print("requestAccessToHealth")
    }
    
    private func requestAccessToUserHealth(){
        print("requestAccessToHealth")
    }
}
