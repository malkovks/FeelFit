//
//  FFOnboardingUserDataViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 06.04.2024.
//

import UIKit
import RealmSwift

protocol FFOnboardingUserDataProtocol: AnyObject {
    func completionUserData(arrayDictionary: [[String: String]]?,text: String?, key: String?)
}

final class FFOnboardingUserDataViewModel {
    weak var delegate: FFOnboardingUserDataProtocol?
    
    private let realm = try! Realm()
    
    let viewController: UIViewController
    var userDataDictionary: [[String:String]]
    var tableView: UITableView
    
    init(viewController: UIViewController, userDataDictionary: [[String:String]], tableView: UITableView) {
        self.viewController = viewController
        self.userDataDictionary = userDataDictionary
        self.tableView = tableView
    }
    
    ///Function load data from system Health application. For using need user's access to Health Character's Data
    @objc func loadHealthData(userData userDataDictionary: [[String:String]],
                              completion: @escaping (_ userData: [String:String]) -> ()){
        guard var dict = userDataDictionary.last else { return }
        
        
        viewController.defaultAlertController(title: nil, message: "Do you want to download medical data from Health?", actionTitle: "Download", style: .alert) {
            FFHealthDataLoading.shared.loadingCharactersData { userDataString in
                guard let data = userDataString else { return }
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
                completion(dict)
            }
        }
    }
    
    
    /// Function open picker view with prepared visual displaying info for selected table view row
    @objc func openPickerView(_ indexPath: IndexPath){
        let index = indexPath.row
        let value: String = returnSelectedValueFromDictionary(index)
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
    
    @objc func changeUserDataValue(_ index: Int, section: Int = 1, text value: String?){
        let indexPath = IndexPath(row: index, section: section)
        
        guard let text = value else {
            viewController.viewAlertController(text: "Value is empty", controllerView: viewController.view)
            return
        }

        let dictionary = userDataDictionary[section]
        let keys: [String] = Array(dictionary.keys).sorted()
        let keyDictionary: String = keys[index]
        tableView.reloadRows(at: [indexPath], with: .automatic)
        delegate?.completionUserData(arrayDictionary: nil, text: text, key: keyDictionary)
    }
    
}

private extension FFOnboardingUserDataViewModel {
    func returnSelectedValueFromDictionary(_ index: Int) -> String {
        let dictionary = userDataDictionary[1]
        let value: String = Array(dictionary.values).sorted()[index]
        return value
    }
}

//Delegate method returning selected result from FFPickerViewDelegate
extension FFOnboardingUserDataViewModel: FFPickerViewDelegate {
    func didReceiveSelectedDate(selectedDate: Date?, index: Int) {
        let dateComponents = selectedDate?.convertDateToDateComponents()
        let dateString = dateComponents?.convertComponentsToDateString()
        changeUserDataValue(index, text: dateString)
    }
    
    func didReceiveSelectedValue(selectedValue: String?, index: Int) {
        changeUserDataValue(index, text: selectedValue)
    }
}
