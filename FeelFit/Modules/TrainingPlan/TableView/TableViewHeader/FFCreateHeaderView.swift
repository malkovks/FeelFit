//
//  FFCreateHeaderView.swift
//  FeelFit
//
//  Created by Константин Малков on 14.11.2023.
//

import UIKit

protocol AddSectionProtocol: AnyObject {
    func addSection()
    func removeSection()
}

class FFCreateHeaderView: UIView {
    
    weak var delegate: AddSectionProtocol?
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = FFResources.Colors.activeColor
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let addSectionButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "plus.rectangle"), for: .normal)
        button.tintColor = FFResources.Colors.activeColor
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.isHidden = true
        return button
    }()
    
    private let removeSectionButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "minus.rectangle"), for: .normal)
        button.tintColor = FFResources.Colors.activeColor
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.isHidden = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = FFResources.Colors.tabBarBackgroundColor
        setupViewConstraints()
        addSectionButton.addTarget(self, action: #selector(didTapButton), for: .primaryActionTriggered)
        removeSectionButton.addTarget(self, action: #selector(didTapToRemove), for: .primaryActionTriggered)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapButton(){
        delegate?.addSection()
    }
    
    @objc private func didTapToRemove(){
        delegate?.removeSection()
    }
    
    func configureHeaderView(section: Int, numberOfSections: Int,text: String){
        titleLabel.text = text
        if section != 0 && section != 1 &&  section != 2 && section != (numberOfSections-1) && numberOfSections < 8 {
            addSectionButton.isHidden = false
        } else {
            addSectionButton.isHidden = true
        }
        
        if numberOfSections > 5 && section != 0 && section != 1 &&  section != 2 && section != (numberOfSections-1) {
            removeSectionButton.isHidden = false
        }
        
    }
    
    private func setupViewConstraints(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(5)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        addSubview(addSectionButton)
        addSectionButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(5)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
        
        addSubview(removeSectionButton)
        removeSectionButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.trailing.equalTo(addSectionButton.snp.leading).offset(-5)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
    }
    
}
