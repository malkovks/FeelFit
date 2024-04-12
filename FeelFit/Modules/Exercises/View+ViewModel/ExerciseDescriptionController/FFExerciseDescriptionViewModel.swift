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
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint,_ exercise: Exercise) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [unowned self]_ in
            let share = UIAction(title: "Share") { _ in
                UIPasteboard.general.string = exercise.imageLink
                self.viewController.viewAlertController(text: "Image link copied!", startDuration: 0.5, timer: 2, controllerView: self.viewController.view)
            }
            let openImage = UIAction(title: "Open Image") { [weak self] _ in
                let imageLink = exercise.imageLink
                let vc = FFImageDetailsViewController(newsImage: nil, imageURL: imageLink)
                self?.viewController.present(vc, animated: true)
            }
            return UIMenu(children: [share,openImage])
        }
    }
}
