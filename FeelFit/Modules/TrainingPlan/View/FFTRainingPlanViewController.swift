//
//  FFTRainingPlanViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import Kingfisher

class FFTRainingPlanViewController: UIViewController,SetupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
    }
    
    func setupImageView(url: String){
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addInteraction(UIContextMenuInteraction(delegate: self))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalToSuperview().inset(10)
        }
        
        guard let url = URL(string: url) else { return }
        let options: KingfisherOptionsInfo = [.processor(DefaultImageProcessor.default),.cacheOriginalImage,.transition(.fade(0.2))]
        imageView.kf.setImage(with: url,options: options)
    }
    
    func setupView() {
        view.backgroundColor = .systemGray4
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No planned trainings"
        config.secondaryText = "Add new training plan to list"
        config.image = UIImage(systemName: "rectangle")
        config.button = .tinted()
        config.buttonProperties.role = .primary
        contentUnavailableConfiguration = config
    }
    
    func setupNavigationController() {
        title = "Plan"
    }
    

}

extension FFTRainingPlanViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let share = UIAction(title: "Share") { _ in
                print("Share image")
            }
            return UIMenu(children: [share])
        }
    }
    
    
}
