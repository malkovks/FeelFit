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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key: String = Array(muscleDictionary.keys.sorted())[indexPath.row]
        
        let keyValue: String = key.replacingOccurrences(of: "_", with: "%20")
        let vc = FFExercisesMuscleGroupViewController(muscleGroupName: keyValue)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 10
        let height = CGFloat(viewController.view.frame.size.height/4)
        return CGSize(width: width, height: height)
    }
}
