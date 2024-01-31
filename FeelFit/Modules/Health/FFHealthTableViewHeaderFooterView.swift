//
//  FFHealthTableViewHeaderFooterView.swift
//  FeelFit
//
//  Created by Константин Малков on 31.01.2024.
//

import UIKit

class FFHealthTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headerFont(size: 24)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = FFResources.Colors.detailTextColor
        return label
    }()
    
    private let headerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        button.tintColor = FFResources.Colors.activeColor
        button.layer.cornerRadius = button.frame.size.width / 2
        button.layer.masksToBounds = true
        return button
    }()
    
    static let identifier = "FFHealthTableViewHeaderFooterView"

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeaderConstraints()
    }
    
    func configureHeader(title: String,_ selector: Selector ){
        headerLabel.text = title
        headerButton.addTarget(self, action: selector, for: .primaryActionTriggered)
    }
    
    private func setupHeaderConstraints(){
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(headerButton)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
