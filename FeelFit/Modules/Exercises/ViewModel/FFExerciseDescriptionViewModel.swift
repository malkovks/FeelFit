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
        let realmModel = FFExerciseModelRealm(exercise: exercise)
        FFLoadAnimatedImage.shared.loadingAnimateImage(exercise: realmModel) { imageView in
            completion(imageView)
        }
    }
}
