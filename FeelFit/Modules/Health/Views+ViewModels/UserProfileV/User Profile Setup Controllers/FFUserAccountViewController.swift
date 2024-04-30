//
//  FFUserAccountViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 28.04.2024.
//

import UIKit

class FFUserAccountViewController: UIViewController {
    
    var userImageView: UIImageView = {
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
    
    var userFullNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Malkov Konstantin"
        label.font = UIFont.headerFont(size: 24)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
}

extension FFUserAccountViewController: SetupViewController {
    func setupView() {
        title = "User account"
        view.backgroundColor = .mintGreen
        setupNavigationController()
        setupViewModel()
        setupConstraints()
    }
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        
    }
    
    
}

extension FFUserAccountViewController {
    func setupConstraints(){
        view.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(view.frame.size.height/5)
        }
        
        view.addSubview(userFullNameLabel)
        userFullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }
        
        
    }
}

#Preview {
    let vc = FFUserAccountViewController()
    let navVC = FFNavigationController(rootViewController: vc)
    navVC.isNavigationBarHidden = false
    navVC.modalPresentationStyle = .pageSheet
    return navVC
}
