//
//  FFExerciseDescriptionViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 02.11.2023.
//

import UIKit
import SafariServices
import Kingfisher

class FFExerciseDescriptionViewModel {
    
    var viewController: UIViewController!
    
    init(viewController: UIViewController!) {
        self.viewController = viewController
    }
    
    func openSafari(exercise: Exercise){
        let url = "https://www.youtube.com/results?search_query="
        let modifiedRequest = exercise.exerciseName.replacingOccurrences(of: " ", with: "+")
        guard let completeURL = URL(string: url+modifiedRequest) else { return }
        openYouTubeWith(link: completeURL)
    }
    
    func openYouTubeWith(link: URL) {
        if UIApplication.shared.canOpenURL(link){
            UIApplication.shared.open(link)
        } else {
            let vc = SFSafariViewController(url: link)
            viewController.present(vc, animated: true)
        }
    }
    
    func loadingImageView(exercise: Exercise,completion: @escaping (UIImageView) -> () )  {
        guard let url = URL(string: exercise.imageLink)  else { return }
        var imageView = UIImageView()
        imageView.kf.setImage(with: url) { result in
            switch result {
            case .success(_):
                completion(imageView)
            case .failure(_):
                completion(UIImageView(image: UIImage(systemName: "figure.strengthtraining.traditional")))
            }
        }
    }
}
