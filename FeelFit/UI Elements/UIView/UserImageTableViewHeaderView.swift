//
//  UserImageTableViewHeaderView.swift
//  FeelFit
//
//  Created by Константин Малков on 25.03.2024.
//

import UIKit

class UserImageTableViewHeaderView: UIView {
    
    
    
    private var userImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle")!)
        imageView.tintColor = .griRed
        imageView.setupShadowLayer()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var userFullNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Malkov Konstantin"
        label.font = UIFont.headerFont(size: 24)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupHeaderViewConstraints()
    }
    
    @objc private func didTapOpenImagePicker(_ gesture: UITapGestureRecognizer){
        
    }
    
    private func setupHeaderViewConstraints(){
        stackView.addArrangedSubview(userImageView)
        stackView.addArrangedSubview(userFullNameLabel)
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.95)
        }
        userImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualToSuperview()
            make.height.greaterThanOrEqualToSuperview().multipliedBy(0.8)
        }
        
        userFullNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            make.bottom.equalToSuperview()
        }
    }
    //Доделать изображение чтобы было круглым после присвоения нового
    private func setupImageView(){
        userImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.layer.masksToBounds = true
        
        
    }
    
    func configureImageTarget(selector: Selector,target: Any?){
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        userImageView.addGestureRecognizer(tapGesture)
    }
    
    func configureCustomHeaderView(userImage: UIImage?,isLabelHidden: Bool = false, labelText: String? = "Malkov Konstantin"){
        self.userImageView.image = userImage ?? UIImage(systemName: "person.crop.circle")!
        self.userFullNameLabel.isHidden = isLabelHidden
        self.userFullNameLabel.text = labelText
    }
    
    func configureLongGestureImageTarget(target: Any?, selector: Selector){
        let longGesture = UILongPressGestureRecognizer(target: target, action: selector)
        userImageView.addGestureRecognizer(longGesture)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
