//
//  FFHealthUserInformationViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 24.04.2024.
//

import UIKit

protocol HealthUserInformationDelegate: AnyObject {
    func didReloadTableView(indexPath: IndexPath?)
}



final class FFHealthUserInformationViewModel {
    
    weak var delegate: HealthUserInformationDelegate?
    
    private let viewController: UIViewController
    private let storeManager = FFUserHealthDataStoreManager.shared
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public var userDataDictionary: [[String:String]] = [
        ["Name":"Enter Name",
         "Second Name": "Enter Second Name"],
        ["Birthday":"Not Set",
         "Gender":"Not Set",
         "Blood Type":"Not Set",
         "Skin Type(Fitzpatrick Type)":"Not Set",
         "Stoller chair":"Not Set"],
        ["Load":"Load"],
        ["Save":"Save"]
    ]
    
    private var tableViewData: [[String]] = [
        ["Name","Second Name"],
        ["Birthday","Gender","Blood Type","Skin Type(Fitzpatrick Type)","Stoller chair"],
        ["Load"],
        ["Save"]
    ]
    
    var userData: [[String]] = [
        [],
        []
    ]
    
    private var firstUserData: [[String]] = [[],[]]
    
    func loadFullUserData(){
        userData = storeManager.loadUserDataModel()
        firstUserData = userData
    }
    
    func saveUserData(){
        let value = storeManager.saveUserData(userData)
        switch value {
        case .success(let success):
            if !success {
                viewController.alertError(message: "Error saving model")
            } else {
                viewController.navigationController?.popViewController(animated: true)
            }
        case .failure(let failure):
            viewController.alertError(title: "Error",message: failure.localizedDescription)
        }
    }
    
    func popPresentedController(){
        if firstUserData != userData {
            requestSaveChanges()
        } else {
            viewController.navigationController?.popViewController(animated: true)
        }
    }
    
    private func requestSaveChanges(){
        let alert = UIAlertController(title: "Warning", message: "Do you want to save changes?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self] _ in
            viewController.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [ unowned self] _ in
            saveUserData()
        }))
        viewController.present(alert, animated: true)
    }
    
    private func loadHealthUserData(){
        FFHealthDataManager.shared.loadingCharactersData { [unowned self] data in
            userData[1][0] = data?.dateOfBirth?.convertComponentsToDateString() ?? "Not set"
            userData[1][1] = data?.userGender ?? "Not set"
            userData[1][2] = data?.bloodType ?? "Not set"
            userData[1][3] = data?.fitzpatrickSkinType ?? "Not set"
            userData[1][4] = data?.wheelChairUse ?? "Not set"
            delegate?.didReloadTableView(indexPath: nil)
        }
    }
    
    private func openPickerView(_ indexPath: IndexPath){
        let title = tableViewData[indexPath.section][indexPath.row]
        let value = userData[indexPath.section][indexPath.row]
        let vc = FFPickerViewController(selectedValue: value, tableViewIndex: indexPath.row, title: title, blurEffectStyle: .light, vibrancyEffect: .label)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.tintColor = .main
        nav.modalPresentationStyle = .formSheet
        nav.sheetPresentationController?.detents = [.medium()]
        nav.sheetPresentationController?.prefersGrabberVisible = true
        viewController.present(nav, animated: true)
    }
    
    private func handleSelectedData(value text: String?, section: Int = 1, row: Int){
        let indexPath = IndexPath(row: row, section: section)
        guard let text = text else {
            viewController.alertError(message: "Error handling selected data. Try again later")
            return
        }
        
        userData[section][row] = text
        delegate?.didReloadTableView(indexPath: indexPath)
    }
    
    private func openTextField(indexPath: IndexPath){
        let placeholder = tableViewData[indexPath.section][indexPath.row]
        let text = userData[indexPath.section][indexPath.row]
        let message: String = "Enter \(placeholder)"
        viewController.presentTextFieldAlertController(placeholder: placeholder, keyboardType: .default, text: text, alertTitle: nil, message: message) { [ unowned self] text in
            userData[indexPath.section][indexPath.row] = text
            delegate?.didReloadTableView(indexPath: indexPath)
        }
    }
    
    private func requestToLoadHealthUserData(){
        viewController.defaultAlertController(message: "Do you want to load your own data from Health?", actionTitle: "Load") { [unowned self] in
            loadHealthUserData()
        }
    }
    
    private func leaveCurrentAccount(){
        viewController.defaultAlertController(
            title: "Warning",
            message: "Do you want to leave account",
            actionTitle: "Leave",
            style: .alert,
            buttonStyle: .destructive) { [unowned self] in
                openAuthenticationController()
            }
    }
    
    private func openAuthenticationController(){
        let authVC = FFOnboardingAuthenticationViewController(type:.authenticationOnlyDisplay)
        authVC.modalPresentationStyle = .fullScreen
        viewController.present(authVC, animated: true)
        FFAuthenticationManager.shared.didExitFromAccount()
    }
}

//MARK: - Table view data source
extension FFHealthUserInformationViewModel {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0,1:
            let cell = tableView.dequeueReusableCell(withIdentifier: FFSubtitleTableViewCell.identifier, for: indexPath) as! FFSubtitleTableViewCell
            cell.configureLabels(value: userData, indexPath: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: FFCenteredTitleTableViewCell.identifier, for: indexPath) as! FFCenteredTitleTableViewCell
            cell.configureCell( indexPath: indexPath)
            return cell
        }
    }
}

//MARK: - Table view delegate
extension FFHealthUserInformationViewModel {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            openTextField(indexPath: indexPath)
        case 1:
            openPickerView(indexPath)
        case 2:
            requestToLoadHealthUserData()
        case 3:
            leaveCurrentAccount()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    //Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - Picker view delegate
extension FFHealthUserInformationViewModel: FFPickerViewDelegate {
    func didReceiveSelectedDate(selectedDate: Date?, index: Int) {
        let dateComponents = selectedDate?.convertDateToDateComponents()
        let dateString = dateComponents?.convertComponentsToDateString()
        handleSelectedData(value: dateString, row: index)
    }
    
    func didReceiveSelectedValue(selectedValue: String?, index: Int) {
        handleSelectedData(value: selectedValue, row: index)
    }
}
