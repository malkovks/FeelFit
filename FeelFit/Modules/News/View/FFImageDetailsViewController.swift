//
//  FFImageDetailsViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 17.10.2023.
//

import UIKit

class FFImageDetailsViewController: UIViewController, SetupViewController {
    
    var imageURL: URL?
    
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
    
    private let shareImageViewButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = FFResources.Colors.activeColor
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "square.and.arrow.up.fill"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupConstraints()
    }
    
    @objc private func didTapDismiss(){
        self.dismiss(animated: true)
    }
    
    @objc private func didTapShare(){
        let message = "Check this awesome picture"
        let link = imageURL
        let item = imageView.image!
        let activityVC = UIActivityViewController(activityItems: [link!,item], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.print,.openInIBooks]
        present(activityVC, animated: true)
    }
    
    func setupImageView(string: String){
        guard let url = URL(string: string) else {
            imageView.image = UIImage(systemName: "photo.fill")
            return
        }
        imageURL = url
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.layer.borderColor = FFResources.Colors.tabBarBackgroundColor.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 12
        
        closeViewButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        shareImageViewButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
 
    func setupNavigationController() {
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: nil, imageName: "xmark", action: #selector(didTapDismiss), menu: nil)
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
        
        visualEffectiveView.contentView.addSubview(shareImageViewButton)
        shareImageViewButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(closeViewButton.snp.leading).offset(-20)
            make.height.width.equalToSuperview().dividedBy(9)
        }
        
    }
}

#Preview {
    FFImageDetailsViewController()
}
