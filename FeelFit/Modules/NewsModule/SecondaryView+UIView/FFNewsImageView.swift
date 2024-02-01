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

    
    private func setupVisualView(){
        let style = UIBlurEffect.Style.systemUltraThinMaterialLight
        let visualView = UIBlurEffect(style: style)
        self.effect = visualView
        self.clipsToBounds = true
        self.layer.borderColor = FFResources.Colors.tabBarBackgroundColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 12
        
    }
//    #error("Сделать кнопку")
    private func setupConstraints(){
        contentView.addSubview(closeImageViewButton)
        closeImageViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.trailing.equalToSuperview().offset(100)
            make.height.width.equalTo(25)
        }
        
        let imageSize = contentView.frame.size.width / 1.5
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(imageSize)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
