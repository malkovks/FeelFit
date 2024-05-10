//
//  FFUserProfileViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 01.02.2024.
//

import UIKit
import PhotosUI

class FFUserProfileViewModel: HandleUserImageProtocol {
    
    let headerTextSections = [
        "",
        "Functions",
        "Сonfidentiality",
        ""
    ]
    
    
    let textLabelRows = [
        ["User Profile"
         ,"Medical Card"],
        ["Clean cache data",
         "Clean storage data",
         "Access to Services"],
        ["Application and services",
         "Scientific Research",
         "Devices"],
        ["Exit from account"]
    ]
    
    private let viewController: UIViewController
    
    var mainUserData = FFUserHealthMainData(fullName: "Name - Second Name", account: "No account value")
    var isUserLoggedIn = FFAuthenticationManager.shared.isUserEnteredInAccount()
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    /// Function open details about user's health
    func pushUserHealthData(image: UIImage?){
        let vc = FFHealthUserInformationViewController()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentUserData(){
        let vc = FFUserAccountViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .pageSheet
        navVC.sheetPresentationController?.detents = [.medium()]
        navVC.sheetPresentationController?.prefersGrabberVisible = true
        navVC.isNavigationBarHidden = false
        navVC.navigationBar.tintColor = .main
        viewController.present(navVC, animated: true)
    }
    
    func clearUserCache(){
        viewController.defaultAlertController(title: "Clear cache", message: "Do you want to delete all cached information?", actionTitle: "Delete", style: .alert, buttonStyle: .destructive) {
            print("Delete")
        }
    }
    
    func clearStoreData(){
        guard let textSize = collectRealmStorageWeight() else { return }//подсчет веса данных всех моделей реалма на устройстве
        viewController.defaultAlertController(title: "Clear store data", message: "Storage memory fille on \(textSize) MB.\nDo you want to delete storage and delete all data?", actionTitle: "Delete", style: .alert, buttonStyle: .destructive) {
            print("Delete")
        }
    }
    
    func checkAccessStatus(){
        let vc = FFAccessToServicesViewController()
        let nav = FFNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        nav.isNavigationBarHidden = false
        nav.sheetPresentationController?.detents = [.medium()]
        nav.sheetPresentationController?.prefersGrabberVisible = true
        viewController.present(nav, animated: true)
    }
    

    func exitFromAccount(){
        let id = mainUserData.account
        let alert = UIAlertController(title: "Exit from account", message: "Your ID is \(id) and you want to leave this account.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { [weak self ] _ in
            FFAuthenticationManager.shared.didExitFromAccount()
            let vc = FFOnboardingAuthenticationViewController(type: .authenticationOnlyDisplay)
            vc.modalPresentationStyle = .fullScreen
            self?.viewController.present(vc, animated: true)
            
        }))
        viewController.present(alert, animated: true)
    }
    
    func loadUserData(){
        guard let fullData = FFUserHealthDataStoreManager.shared.mainUserData() else { return }
        mainUserData = fullData
    }
}

//MARK: - Table View data source extension
extension FFUserProfileViewModel {
    func numberOfSections(in tableView: UITableView) -> Int {
        headerTextSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        textLabelRows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFUserProfileTableViewCell.identifier, for: indexPath) as! FFUserProfileTableViewCell
        cell.configureCell(indexPath: indexPath, textArray: textLabelRows)
        return cell
    }
}

//MARK: - Table View delegate extension
extension FFUserProfileViewModel {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case [0,0]:
            presentUserData()
        case [0,1]:
            pushUserHealthData(image: userImage)
        case [1,0]:
            clearUserCache()
        case [1,1]:
            clearStoreData()
        case [1,2]:
            checkAccessStatus()
        case [2,0]:
            print("Информация о приложении и сервисах")
        case [2,1]:
            print("Исследовательская работа. Опциональная строка")
        case [2,2]:
            print("Девайсы. опционально")
        case [3,0]:
            exitFromAccount()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return viewController.view.frame.size.height / 5
        } else if section == tableView.numberOfSections{
            return 0
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let frameRect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: viewController.view.frame.size.height/4-10)
            let customView = UserImageTableViewHeaderView(frame: frameRect)
            customView.configureCustomHeaderView(userImage: userImage,isLabelHidden: false, labelText: mainUserData.fullName)
            return customView
        } else {
            let label = UILabel(frame: CGRect(x: 5, y: 5, width: tableView.frame.width-10, height: 34))
            label.font = UIFont.textLabelFont(size: 24)
            label.text = headerTextSections[section]
            label.textAlignment = .left
            let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
            customView.addSubview(label)
            return customView
        }
    }
}
