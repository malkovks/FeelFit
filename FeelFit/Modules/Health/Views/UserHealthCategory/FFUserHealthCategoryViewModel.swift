//
//  FFUserHealthCategoryViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 15.04.2024.
//

import UIKit
import HealthKit

class FFUserHealthCategoryViewModel {
    
    var userFavouriteHealthCategoryArray = [[FFUserHealthDataProvider]]()
    
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func presentUserProfilePage(){
        let vc = FFHealthUserProfileViewController()
        let navVC = FFNavigationController(rootViewController: vc)
        viewController.present(navVC, animated: true)
    }
    
    func refreshView(){
        //download data from health
        loadFavouriteUserHealthCategory()
        //download user image from file manager
        //reload collection view
        
    }
    
    func pushHealthCategory(){
        let vc = FFHealthSettingsViewController()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushSelectedHealthCategory(selectedItem indexPath: IndexPath){
        guard let identifier = userFavouriteHealthCategoryArray[indexPath.row].first?.typeIdentifier else { return }
        let vc = FFUserDetailCartesianChartViewController(typeIdentifier: identifier)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadFavouriteUserHealthCategory(){
        let userFavouriteTypes: [HKQuantityTypeIdentifier] = FFHealthData.favouriteQuantityTypeIdentifier
        let startDate = Calendar.current.startOfDay(for: Date())
        FFHealthDataLoading.shared.performQuery(identifications: userFavouriteTypes, 
                                                selectedOptions: nil, startDate: startDate) { [weak self] models in
            guard let model = models,
                  let self = self else {
                return
            }
            userFavouriteHealthCategoryArray = model
        }
    }
    //Load from UserImageManager
    func loadUserImage(){
        do {
            
        } catch {
            
        }
    }
    
}
