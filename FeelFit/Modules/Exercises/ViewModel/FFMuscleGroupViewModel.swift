//
//  FFMuscleGroupViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 30.10.2023.
//

import UIKit
import RealmSwift

class FFMuscleGroupViewModel {
    
    private let realm = try! Realm()
    
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func setupConfiguration(action: @escaping () -> ()) -> UIContentUnavailableConfiguration{
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No exercises"
        config.secondaryText = "Press plus to load data"
        config.image = UIImage(systemName: "figure.strengthtraining.traditional")
        config.button = .tinted()
        config.button.image = UIImage(systemName: "plus.rectangle")
        config.button.title = "Refresh"
        config.button.imagePlacement = .top
        config.button.imagePadding = 2
        config.button.baseBackgroundColor = FFResources.Colors.activeColor
        config.button.baseForegroundColor = FFResources.Colors.activeColor
        config.buttonProperties.primaryAction = UIAction(handler: { _ in
            action()
        })
        return config
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FFExercisesCollectionViewCell
        let key: String = Array(cell.muscleDictionary.keys.sorted())[indexPath.row]
        
        let keyValue: String = key.replacingOccurrences(of: "_", with: "%20")
        
        print(keyValue)
        let vc = FFExercisesMuscleGroupViewController(muscleGroupName: keyValue)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 10
        let height = CGFloat(viewController.view.frame.size.height/4)
        return CGSize(width: width, height: height)
    }
}
