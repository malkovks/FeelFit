//
//  FFUserHealthCategoryViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 15.04.2024.
//

import UIKit
import HealthKit

protocol UserHealthCategoryDelegate: AnyObject {
    func didTapReloadView()
}

protocol UserHealthCategorySetting: AnyObject {
    var delegate: UserHealthCategoryDelegate? { get set }
    func presentUserProfilePage()
    func refreshView()
    func presentHealthCategories()
    func pushSelectedHealthCategory(selectedItem indexPath: IndexPath)
    func loadFavouriteUserHealthCategory()
    func loadUserImage()
}

class FFUserHealthCategoryViewModel: UserHealthCategorySetting {
    
    weak var delegate: UserHealthCategoryDelegate?
    
    var userFavouriteHealthCategoryArray = [[FFUserHealthDataProvider]]()
    var userProfileImage: UIImage?
    
    private let group = DispatchGroup()
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func presentUserProfilePage(){
        let vc = FFHealthUserProfileViewController()
        let navVC = FFNavigationController(rootViewController: vc)
        viewController.present(navVC, animated: true)
    }
    
    func refreshView(){
        loadFavouriteUserHealthCategory()
        loadUserImage()
    }
    
    func presentHealthCategories(){
        let vc = FFFavouriteHealthDataViewController()
        vc.isViewDismissed = { [weak self] in
            self?.delegate?.didTapReloadView()
        }
        let navVC = FFNavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = false
        viewController.present(navVC, animated: true)
    }
    
    func pushSelectedHealthCategory(selectedItem indexPath: IndexPath){
        guard let identifier = userFavouriteHealthCategoryArray[indexPath.row].first?.typeIdentifier else { return }
        let vc = FFHealthCategoryCartesianViewController(typeIdentifier: identifier)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadFavouriteUserHealthCategory(){
        let userFavouriteTypes: [HKQuantityTypeIdentifier] = FFHealthData.favouriteQuantityTypeIdentifier
        let startDate = Calendar.current.startOfDay(for: Date())
        FFHealthDataManager.shared.performQuery(identifications: userFavouriteTypes, 
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
        let userImagePartialName = UserDefaults.standard.string(forKey: "userProfileFileName") ?? "userImage.jpeg"
        do {
            let image = try FFUserImageManager.shared.loadUserImage(userImagePartialName)
            self.userProfileImage = image
        } catch let error as UserImageErrorHandler {
            viewController.alertError(title: "Error",message: error.errorDescription)
        } catch {
            fatalError("Fatal error loading image from users directory")
        }
    }
    
}
