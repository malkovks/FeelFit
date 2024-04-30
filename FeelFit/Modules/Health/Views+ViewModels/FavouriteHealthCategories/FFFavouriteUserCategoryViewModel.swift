//
//  FFFavouriteUserCategoryViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 24.04.2024.
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

class FFFavouriteUserCategoriesViewModel: UserHealthCategorySetting {
    
    weak var delegate: UserHealthCategoryDelegate?
    
    var userFavouriteHealthCategoryArray =  [[FFUserHealthDataProvider]]()
    var userProfileImage: UIImage?
    
    private let group = DispatchGroup()
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func presentUserProfilePage(){
        let vc = FFUserProfileViewController()
        let navVC = FFNavigationController(rootViewController: vc)
        viewController.present(navVC, animated: true)
    }
    
    func refreshView(){
        loadFavouriteUserHealthCategory()
        loadUserImage()
    }
    
    @objc func presentHealthCategories(){
        let vc = FFHealthCategoriesViewController()
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

        
        let _ = userFavouriteTypes.compactMap { identifier in
            
            FFHealthDataManager.shared.loadSelectedIdentifierData(filter:nil, identifier: identifier, startDate: startDate) { model in
                
                guard let model = model else {
                    return }
                self.userFavouriteHealthCategoryArray.append(model)
                self.userFavouriteHealthCategoryArray.sort { $0[0].identifier < $1[0].identifier }
            }
        }
    }
    //Load from UserImageManager
    func loadUserImage(){
        let userImagePartialName = UserDefaults.standard.string(forKey: "userProfileFileName") ?? "userImage.jpeg"
        do {
            let image = try FFUserImageManager.shared.loadUserImage(userImagePartialName)
            self.userProfileImage = image
        } catch let error as UserImageErrorHandler {
            print(error.errorDescription)
        } catch {
            fatalError("Fatal error loading image from users directory")
        }
    }
}

//MARK: - Collection view Data Source
extension FFFavouriteUserCategoriesViewModel {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userFavouriteHealthCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFPresentHealthCollectionViewCell.identifier, for: indexPath) as! FFPresentHealthCollectionViewCell
        let data = userFavouriteHealthCategoryArray[indexPath.row]
        cell.configureCell(indexPath, values: data)
        return cell
    }
}
//MARK: - Collection view Delegate
extension FFFavouriteUserCategoriesViewModel {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        pushSelectedHealthCategory(selectedItem: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FFPresentHealthHeaderCollectionView.identifier, for: indexPath) as! FFPresentHealthHeaderCollectionView
            header.configureHeaderCollectionView(selector: #selector(presentHealthCategories), target: self)
            return header
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FFPresentHealthFooterCollectionView.identifier, for: indexPath) as! FFPresentHealthFooterCollectionView
        footer.configureButtonTarget(target: self, selector: #selector(presentHealthCategories))
        return  footer
    }
}
//MARK: - Collection view delegate flow layout
extension FFFavouriteUserCategoriesViewModel {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width-20
        let height = CGFloat(viewController.view.frame.size.height/4)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width-10, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width-10, height: 60)
    }
}
