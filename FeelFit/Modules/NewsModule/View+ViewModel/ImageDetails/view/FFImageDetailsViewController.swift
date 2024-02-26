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
    
    @objc private func didPinchImageGesture(_ gesture: UIPinchGestureRecognizer){
        guard let gestureView = gesture.view else { return }
        if gesture.state == .changed {
            let scale = gesture.scale
            let currentTransform = gestureView.transform
            let newTransform = currentTransform.scaledBy(x: scale, y: scale)
            let origScale = max(newTransform.a, newTransform.d)
            
            if origScale >= 1.0 {
                gestureView.transform = newTransform
            }
            
            gesture.scale = 1.0
            
        }
//        let currentScale = view.frame.size.width / view.bounds.size.width
//        var newScale = gesture.scale * currentScale
//        
//        
//        let minimalScale = 0.5
//        if newScale >= minimalScale {
//            newScale = minimalScale
//        }
//        
//        gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
//        gesture.scale = 1.0
    }
    
    @objc private func didPanImageGesture(_ gesture: UIPanGestureRecognizer){
        guard let gestureImage = gesture.view else { return }
        let translation = gesture.translation(in: gestureImage.superview)
        gestureImage.center = CGPoint(x: gestureImage.center.x+translation.x, y: gestureImage.center.y+translation.y)
        gesture.setTranslation(.zero, in: gestureImage.superview)
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
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchImageGesture))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanImageGesture))
        imageView.addGestureRecognizer(panGesture)
        
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
