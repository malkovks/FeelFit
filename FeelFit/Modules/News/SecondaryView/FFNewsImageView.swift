//
//  FFNewsImageView.swift
//  FeelFit
//
//  Created by Константин Малков on 06.10.2023.
//

import UIKit

///View for displaying selected image view blur effect
class FFNewsImageView: UIVisualEffectView {
    var isOpened: ((Bool) -> Void)?
    
    let imageView: UIImageView = {
       let image = UIImageView(image: UIImage(systemName: "photo.fill"))
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 12
        image.tintColor = FFResources.Colors.activeColor
        image.backgroundColor = .clear
        image.clipsToBounds = true
        return image
    }()
    
    let closeImageViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.tintColor = FFResources.Colors.activeColor
        button.layer.cornerRadius = button.frame.size.width/2
        button.backgroundColor = .clear
        return button
    }()
    
    let shareImageViewButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up.fill"), for: .normal)
        button.imageView?.tintColor = FFResources.Colors.activeColor
        button.backgroundColor = .clear
        return button
    }()
    
    override init(effect: UIVisualEffect?){
        super.init(effect: effect)
        setupConstraints()
        setupVisualView()
        closeImageViewButton.addTarget(self, action: #selector(didTapCloseView), for: .touchUpInside)
    }
    
    @objc private func didTapCloseView(sender: UIButton){
        UIView.animate(withDuration: 0.5,delay: 0) {
            self.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { success in
            self.removeFromSuperview()
            self.isOpened?(false)
        }
    }
    
    @objc private func didTapShareImageView(sender: UIButton){
        var items = [Any]()
        items.append(imageView.image)
        let activityView = UIActivityViewController.init(activityItems: items, applicationActivities: nil)
//        present
        
    }
    
    private func setupVisualView(){
        let style = UIBlurEffect.Style.systemChromeMaterialLight
        let visualView = UIBlurEffect(style: style)
        self.effect = visualView
        self.clipsToBounds = true
        self.layer.borderColor = FFResources.Colors.tabBarBackgroundColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 12
        
    }
    
    private func setupConstraints(){
        contentView.addSubview(closeImageViewButton)
        closeImageViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.width.equalTo(25)
        }
        
        contentView.addSubview(shareImageViewButton)
        shareImageViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalTo(closeImageViewButton.snp.leading).offset(-15)
            make.height.width.equalTo(25)
        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
