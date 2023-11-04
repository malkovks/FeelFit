//
//  FFImageDetailsViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 17.10.2023.
//

import UIKit

class FFImageDetailsViewModel: Coordinating {
    var coordinator: Coordinator?
    
    func shareImageView(viewController: UIViewController,url: URL?,title: String, image: UIImage){
        let message = title
        let image = image
        guard let link = url else { return }
        let activityVC = UIActivityViewController(activityItems: [message,image,link], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.print,.openInIBooks]
        viewController.present(activityVC, animated: true)
    }
    
    func dismissViewController(viewController: UIViewController){
        viewController.dismiss(animated: true)
    }
}
