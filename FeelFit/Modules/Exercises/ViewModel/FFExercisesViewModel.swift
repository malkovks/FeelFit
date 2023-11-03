//
//  FFExercisesViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 30.10.2023.
//

import UIKit

class FFExercisesViewModel {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, viewController: UIViewController) {
        let cell = collectionView.cellForItem(at: indexPath) as! FFExercisesCollectionViewCell
        let name = cell.muscleTitleLabel.text ?? ""
        let vc = FFExercisesMuscleGroupViewController(muscleGroupName: name)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath,viewController: UIViewController) -> CGSize {
        let width = collectionView.bounds.width / 2 - 10
        let height = CGFloat(viewController.view.frame.size.height/4)
        return CGSize(width: width, height: height)
    }
}
