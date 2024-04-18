//
//  FFOnboardingUserDataViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 06.04.2024.
//

import UIKit
import RealmSwift

protocol FFOnboardingUserDataProtocol: AnyObject {
    func didLoadUserData(isDataLoaded: Bool)
    func didUserSavedData(isSaved: Bool)
    func didReceiveSelectedData(isReceived: Bool, indexPath: IndexPath?)
}

final class FFOnboardingUserDataViewModel {
    weak var delegate: FFOnboardingUserDataProtocol?
    
    private let realm = try! Realm()
    
    
    public var userDataDictionary: [[String:String]] = [
        ["Name":"Enter Name",
         "Second Name": "Enter Second Name"],
        ["Birthday":"Not Set",
         "Gender":"Not Set",
         "Blood Type":"Not Set",
         "Skin Type(Fitzpatrick Type)":"Not Set",
         "Stoller chair":"Not Set"],
        ["Load": "Load data from Health"],
        ["Save":"Save Data"]
    ]
    
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    ///Function load data from system Health application. For using need user's access to Health Character's Data
    @objc func loadHealthData(userData userDataDictionary: [[String:String]]) {
        var dict = userDataDictionary[1]
        
        
        viewController.defaultAlertController(title: nil, message: "Do you want to download medical data from Health?", actionTitle: "Download", style: .alert) { [weak self] in
            guard let self = self else {
                self?.delegate?.didLoadUserData(isDataLoaded: false)
                return
            }
            FFHealthDataManager.shared.loadingCharactersData { userDataString in
                guard let data = userDataString else {
                    self.delegate?.didLoadUserData(isDataLoaded: false)
                    return
                }
                for (key,_) in dict {
                    switch key {
                    case "Birthday":
                        dict[key] = data.dateOfBirth?.convertComponentsToDateString() ?? "Not Set"
                    case "Gender":
                        dict[key] = data.userGender ?? "Not Set"
                    case "Blood Type":
                        dict[key] = data.bloodType ?? "Not Set"
                    case "Skin Type(Fitzpatrick Type)":
                        dict[key] = data.fitzpatrickSkinType ?? "Not Set"
                    default:
                        dict[key] = "Not Set"
                        break
                    }
                }
                self.delegate?.didLoadUserData(isDataLoaded: true)
                self.userDataDictionary[1] = dict
            }
        }
    }
    
    
    /// Function open picker view with prepared visual displaying info for selected table view row
    @objc func openPickerView(_ indexPath: IndexPath, userData: [[String:String]]){
        let index = indexPath.row
        let value: String = returnSelectedValueFromDictionary(index,userDictionary: userData)
        let vc = FFPickerViewController(selectedValue: value,
                                        tableViewIndex: index,
                                        blurEffectStyle: .dark,
                                        vibrancyEffect: .none)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        nav.sheetPresentationController?.detents = [.custom(resolver: { context in
            return self.viewController.view.frame.size.height * 0.5
        })]
        nav.sheetPresentationController?.prefersGrabberVisible = true
        viewController.present(nav,animated: true)
    }
    
    @objc func changeUserDataValue(_ index: Int, section: Int = 1, text value: String?,userData: [[String:String]]){
        let indexPath = IndexPath(row: index, section: section)
        
        guard let text = value else {
            delegate?.didReceiveSelectedData(isReceived: false, indexPath: nil)
            viewController.viewAlertController(text: "Value is empty", controllerView: viewController.view)
            return
        }

        //доделать наследование словаря. Либо в делегат от пикервью либо иначе
        let dictionary = userDataDictionary[section]
        let keys: [String] = Array(dictionary.keys).sorted()
        let keyDictionary: String = keys[index]
        userDataDictionary[section][keyDictionary] = text
        delegate?.didReceiveSelectedData(isReceived: true, indexPath: indexPath)
    }
    
    @objc func openWelcomeView(user userDataDictionary: [[String:String]]){
        UserDefaults.standard.setValue(true, forKey: "isOnboardingOpenedFirst")
        let name = userDataDictionary[0]["Name"]
        let vc = FFWelcomeViewController(welcomeLabelText: name)
        vc.modalPresentationStyle = .fullScreen
        UIView.transition(with: viewController.view, duration: 1, options: .transitionFlipFromTop, animations: {
            self.viewController.present(vc, animated: true)
        }, completion: nil)
    }
    
    func saveUserData(userData: [[String:String]]){
        let manager = FFUserHealthDataStoreManager.shared
        let resultSavingData = manager.saveNewUserData(userData)
        switch resultSavingData {
        case .success(_):
            openWelcomeView(user: userData)
        case .failure(_):
            delegate?.didUserSavedData(isSaved: false)
        }
    }
}

private extension FFOnboardingUserDataViewModel {
    func returnSelectedValueFromDictionary(_ index: Int, userDictionary: [[String:String]]) -> String {
        let dictionary = userDictionary[1]
        let value: String = Array(dictionary.values).sorted()[index]
        return value
    }
}

//Delegate method returning selected result from FFPickerViewDelegate
extension FFOnboardingUserDataViewModel: FFPickerViewDelegate {
    func didReceiveSelectedDate(selectedDate: Date?, index: Int) {
        let dateComponents = selectedDate?.convertDateToDateComponents()
        let dateString = dateComponents?.convertComponentsToDateString()
        changeUserDataValue(index, text: dateString, userData: userDataDictionary)
    }
    
    func didReceiveSelectedValue(selectedValue: String?, index: Int) {
        changeUserDataValue(index, text: selectedValue, userData: userDataDictionary)
    }
}

//MARK: - TableViewDelegate methods
extension FFOnboardingUserDataViewModel {
    //Table view elements height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return viewController.view.frame.size.height / 5
        } else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 55
        } else {
            return 5
        }
    }
    
    //Setup header and footer
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int,userImage image: UIImage?, isLabelHidden status: Bool,didTapImage selector: Selector, longPress longSelector: Selector, target: Any) -> UIView? {
        let frameRect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: viewController.view.frame.size.height/4-10)
        let customView = UserImageTableViewHeaderView(frame: frameRect)
        customView.configureCustomHeaderView(userImage: image ,isLabelHidden: status)
        customView.configureImageTarget(selector: selector, target: target)
        customView.configureLongGestureImageTarget(target: target, selector: longSelector)
        return customView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dictionary = userDataDictionary[indexPath.section]
        let key: String = Array(dictionary.keys).sorted()[indexPath.row]
        let value: String = dictionary[key] ?? ""
        
        switch indexPath.section {
        case 0:
            viewController.presentTextFieldAlertController(placeholder: "Enter value",text: value,alertTitle: "Enter User Data",message: "Write Your Name and Second Name") { [unowned self] text in
                self.changeUserDataValue(indexPath.row,section: indexPath.section, text: text, userData: userDataDictionary)
            }
        case 1:
            openPickerView(indexPath,userData: userDataDictionary)
        case 2:
            loadHealthData(userData: userDataDictionary)
        case 3:
            saveUserData(userData: userDataDictionary)
        default:
            break
        }
    }
}
