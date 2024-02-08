//
//  File.swift
//  FeelFit
//
//  Created by Константин Малков on 05.02.2024.
//

import UIKit

class FFNavigationControllerCustomView: UIView {
    let navigationTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.headerFont(size: 30)
        label.textAlignment = .left
        label.contentMode = .left
        label.numberOfLines = 1
        label.textColor = FFResources.Colors.textColor
        return label
    }()
    
    let navigationButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "user"), for: .normal)
        button.tintColor = FFResources.Colors.activeColor
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupFrames()
    }
    
    
    func configureView(title text: String,_ image: UIImage = UIImage(systemName: "person")! ){
        navigationTitleLabel.text = text
        navigationButton.setImage(image, for: .normal)
    }
    
    func setupView(){
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = .clear
    }
    
    func setupFrames(){
        
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        addSubview(navigationTitleLabel)
        navigationTitleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width-60, height: 50)
        addSubview(navigationButton)
        navigationButton.frame = CGRect(x: self.frame.size.width-70, y: 0, width: 40, height: 40)
        navigationButton.layer.cornerRadius = navigationButton.frame.size.width / 2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
