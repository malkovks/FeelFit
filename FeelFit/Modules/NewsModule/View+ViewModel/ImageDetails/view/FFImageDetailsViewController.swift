//
//  FFImageDetailsViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 17.10.2023.
//

import UIKit
import Kingfisher

class FFImageDetailsViewController: UIViewController, SetupViewController {
    
    var viewModel: FFImageDetailsViewModel!
    
    var imageURL: URL?
    private var newsImage: UIImage?
    
    init(newsImage: UIImage?,imageURL: String){
        self.imageURL = URL(string: imageURL)
        self.newsImage = newsImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
       let image = UIImageView(image: UIImage(systemName: "photo.fill"))
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 12
        image.tintColor = FFResources.Colors.activeColor
        image.backgroundColor = .clear
        image.clipsToBounds = true
        return image
    }()
    
    private let closeViewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = FFResources.Colors.activeColor
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
        setupNavigationController()
        setupConstraints()
        setupImageView()
    }
    
    @objc private func didTapDismiss(){
        viewModel.dismissViewController(viewController: self)
    }
    
    @objc private func didTapShare(){
        viewModel.shareImageView(viewController: self, url: imageURL, title: "Check this picture", image: imageView.image!)
    }
    
    func setupViewModel() {
        viewModel = FFImageDetailsViewModel()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.layer.borderColor = FFResources.Colors.tabBarBackgroundColor.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 12
        
        closeViewButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
    }
 
    func setupNavigationController() {
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "", imageName: "xmark", action: #selector(didTapDismiss), menu: nil)
    }
    
    func setupImageView(){
        if let image = newsImage {
            imageView.image = image
        } else {
            imageView.kf.setImage(with: imageURL)
        }
    }

}
extension FFImageDetailsViewController {
    private func setupConstraints(){
        let style = UIBlurEffect.Style.systemUltraThinMaterialLight
        let visualView = UIBlurEffect(style: style)
        let visualEffectiveView = UIVisualEffectView(frame: self.view.bounds)
        visualEffectiveView.effect = visualView
        self.view.addSubview(visualEffectiveView)
        visualEffectiveView.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        visualEffectiveView.contentView.addSubview(closeViewButton)
        closeViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.height.width.equalToSuperview().dividedBy(9)
        }
    }
}
