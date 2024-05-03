//
//  UserImageTableViewHeaderView.swift
//  FeelFit
//
//  Created by Константин Малков on 25.03.2024.
//

import UIKit

class UserImageTableViewHeaderView: UIView {
    
    private let defaultImage: UIImage = UIImage(systemName: "person.circle")!.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
    
    private var userImageView: UIImageView = {
        let image = UIImage(systemName: "person.circle")!
        let scaledImage = image.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
        let imageView = UIImageView(image: scaledImage )
        imageView.tintColor = .main
        imageView.setupShadowLayer()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private var userFullNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Name - Second Name"
        label.font = UIFont.headerFont(size: 24)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderViewConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.size.height / 2
    }
    
    private func setupHeaderViewConstraints(){
        let imageSize = self.frame.size.height * 0.8
        
        self.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(imageSize)
        }
        
        self.addSubview(userFullNameLabel)
        userFullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    func configureImageTarget(selector: Selector,target: Any?){
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        userImageView.addGestureRecognizer(tapGesture)
    }
    
    func configureCustomHeaderView(userImage: UIImage?,isLabelHidden: Bool = false, labelText: String? = "Malkov Konstantin"){
        self.userImageView.image = userImage
        self.userFullNameLabel.isHidden = isLabelHidden
        self.userFullNameLabel.text = labelText
        if isLabelHidden {
            userImageView.snp.updateConstraints { make in
                make.width.height.equalTo(self.frame.size.height * 0.8)
            }
        } else {
            userImageView.snp.updateConstraints { make in
                make.width.height.equalTo(self.frame.size.height * 0.6)
            }
        }
    }
    
    func configureChangeUserName(target: Any?, selector: Selector){
        let gesture = UITapGestureRecognizer(target: target, action: selector)
        userFullNameLabel.addGestureRecognizer(gesture)
    }
    
    func configureLongGestureImageTarget(target: Any?, selector: Selector){
        let longGesture = UILongPressGestureRecognizer(target: target, action: selector)
        userImageView.addGestureRecognizer(longGesture)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
