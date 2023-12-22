//
//  FFLoadAnimatedImage.swift
//  FeelFit
//
//  Created by Константин Малков on 22.12.2023.
//

import UIKit
import Kingfisher

class FFLoadAnimatedImage {
    static let shared = FFLoadAnimatedImage()
    
    private var imageView = UIImageView()
    
    func loadingAnimateImage(exercise: FFExerciseModelRealm,animated: Bool = true ,completion: @escaping (UIImageView) -> ()) {
        guard let url = URL(string: exercise.exerciseImageLink) else { return }
        let cacheKey = url.absoluteString
        let id = exercise.exerciseID
        if KingfisherManager.shared.cache.isCached(forKey: cacheKey) {
            loadCachedImageView(url: url, cacheKey, id) { imageView in
                completion(imageView)
            }
        } else {
            loadImageView(url: url, cacheKey, id) { imageView in
                completion(imageView)
            }
        }
    }
    
    private func loadCachedImageView(url: URL,_ cacheKey: String,_ exerciseID: String,handler: @escaping (UIImageView) -> ()){
        imageView.kf.setImage(with: url, options: [.onlyFromCache]) { [unowned self] result in
            switch result {
            case .success(_):
                handler(imageView)
            case .failure(_):
                loadImageView(url: url, cacheKey, exerciseID) { imageView in
                    handler(imageView)
                }
            }
        }
    }
    
    private func loadImageView(url: URL,_ cacheKey: String,_ id: String ,handler: @escaping (UIImageView) -> ()) {
        imageView.kf.setImage(with: url) { [unowned self]  result in
            switch result {
            case .success(let value):
                guard let data = value.image.kf.gifRepresentation() else { return }
                KingfisherManager.shared.cache.storeToDisk(data, forKey: cacheKey)
                handler(imageView)
            case .failure(_):
                FFGetExercisesDataBase.shared.getUpdateImageLinkBy(exerciseID: id)
                handler(UIImageView(image: UIImage(systemName: "figure.strengthtraining.traditional")))
            }
        }
    }
}
