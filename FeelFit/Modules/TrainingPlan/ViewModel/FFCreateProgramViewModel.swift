//
//  FFCreateProgramViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 13.11.2023.
//

import UIKit

enum ButtonTypeMenu {
    case duration, location, trainingType
}


enum TableViewSelection {
    enum BasicSettings {
        case duration, location, type, date
    }
    
    enum WarmUp {
        case duration, type
    }
    
    enum Exercise {
        case approaches, repeats, exercise
    }
    
    enum Hitch {
        case duration, type
    }
}

protocol ButtonMenuPressed: AnyObject {
    func menuDidSelected(text: String,_ indexPath: IndexPath)
}

class FFCreateProgramViewModel: NSObject {
    
    
    weak var delegate: ButtonMenuPressed?
    
    var textData = [
        ["Name Of Workout"],
        ["Full Duration","Location","Type","Training Date"],
        ["Duration","Type"],
        ["Approaches","Repeats","Exercise"],
        ["Duration","Cool Down Type"]
    ]
    
    var detailTextData = [[""],
                          ["Duration","Location","Type","Training"],
                          ["Not selected","Not selected"],
                          ["Not selected","Not selected","Not Selected"],
                          ["Not selected","Not selected"]
                        ]
    
    var titleHeaderViewString: [String] = [
        "",
        "Basic Settings"
        ,"Warm Up"
        ,"Exercise №1"
        ,"Hitch"
    ]
    
    let viewController: UIViewController
    let tableView: UITableView
    
    init(viewController: UIViewController, tableView: UITableView) {
        self.viewController = viewController
        self.tableView = tableView
    }
//    
//    func chosenMenuType(_ type: ButtonTypeMenu,_ indexPath: IndexPath) -> UIMenu {
//        switch type {
//        case .duration:
//            return durationTypeMenu(indexPath)
//        case .location:
//            return locationTypeMenu(indexPath)
//        case .trainingType:
//            return trainingTypeMenu(indexPath)
//        }
//    }
//    
//    private func durationTypeMenu(_ indexPath: IndexPath) -> UIMenu{
//        var actions: [UIAction] {
//            [UIAction(title: "5 minutes", handler: { _ in
//                self.delegate?.menuDidSelected(text: "5 minutes", indexPath)
//            }),
//             UIAction(title: "10 minutes", handler: { _ in
//                self.delegate?.menuDidSelected(text: "10 minutes", indexPath)
//            }),
//             UIAction(title: "15 minutes", handler: { _ in
//                self.delegate?.menuDidSelected(text: "15 minutes", indexPath)
//            }),
//             UIAction(title: "30 minutes", handler: { _ in
//                self.delegate?.menuDidSelected(text: "30 minutes", indexPath)
//            }),
//             UIAction(title: "60 minutes", handler: { _ in
//                self.delegate?.menuDidSelected(text: "60 minutes", indexPath)
//            }),
//             UIAction(title: "90 minutes", handler: { _ in
//                self.delegate?.menuDidSelected(text: "90 minutes", indexPath)
//            }),
//             UIAction(title: "120 minutes", handler: { _ in
//                self.delegate?.menuDidSelected(text: "120 minutes", indexPath)
//            })
//            ]
//        }
//        let menu = UIMenu(children: actions)
//        return menu
//    }
    
//    func selectedSectionRow(tableView: UITableView,indexPath: IndexPath) -> TableViewSelection {
//        if indexPath ==
//    }
//    
//    private func locationTypeMenu(_ indexPath: IndexPath) -> UIMenu{
//        var actions: [UIAction] {
//            [UIAction(title: "Outside", handler: { _ in
//                self.delegate?.menuDidSelected(text: "Outside", indexPath)
//            }),
//             UIAction(title: "Inside", handler: { _ in
//                self.delegate?.menuDidSelected(text: "Inside", indexPath)
//            })
//            ]
//        }
//        var menu = UIMenu(children: actions)
//        return menu
//    }
//    
    private func trainingTypeMenu(_ indexPath: IndexPath) -> UIMenu{
        var actions: [UIAction] {
            [UIAction(title: "Cardio", handler: { [unowned self] _ in
                
                detailTextData[1][2] = "Cardio"
                tableView.reloadData()
            }),
             UIAction(title: "Strength", handler: { [unowned self] _ in
                detailTextData[1][2] = "Strength"
                tableView.reloadData()
            }),
             UIAction(title: "Endurance", handler: { [unowned self] _ in
                detailTextData[1][2] = "Endurance"
                tableView.reloadData()
            }),
             UIAction(title: "Flexibility", handler: { [unowned self] _ in
                detailTextData[1][2] = "Flexibility"
                tableView.reloadData()
            }),
            ]
        }
        
        var menu = UIMenu(children: actions)
        return menu
    }
//    
//    
//    @objc private func didTapPress(sender: IndexPath){
//        print(sender.row)
//    }
//    
    //MARK: - TableViewData Source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFCreateTableViewCell.identifier, for: indexPath) as! FFCreateTableViewCell
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.up.chevron.down"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        button.tintColor  = .systemRed
        button.menu = trainingTypeMenu(indexPath)
        button.showsMenuAsPrimaryAction = true
        cell.accessoryView = button
        cell.configureTableViewCell(tableView: tableView, indexPath: indexPath, text: textData, actionLabel: detailTextData)
        return cell
    }

    
    //MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var tableSection = tableView.numberOfSections-2
        switch (indexPath.section, indexPath.row ){
        case (1,0):     alertController(title: "\(indexPath.section)", message: "\(indexPath.row)")
        case (1,1):     alertController(title: "\(indexPath.section)", message: "\(indexPath.row)")
        case (1,2):     alertController(title: "\(indexPath.section)", message: "\(indexPath.row)")
        case (1,3):     alertController(title: "\(indexPath.section)", message: "\(indexPath.row)")
        case (2,0):     alertController(title: "\(indexPath.section)", message: "\(indexPath.row)")
        case (2,1):     alertController(title: "\(indexPath.section)", message: "\(indexPath.row)")
        case (tableSection,0): 		alertController(title: "\(indexPath.section)", message: "\(indexPath.row)")
        case (tableSection,1): 		alertController(title: "\(indexPath.section)", message: "\(indexPath.row)")
        case (tableSection,2): 		alertController(title: "\(indexPath.section)", message: "\(indexPath.row)")
        case (tableSection+1,0): alertController(title: "\(indexPath.section)", message: "\(indexPath.row)")
        case (tableSection+1,1): alertController(title: "\(indexPath.section)", message: "\(indexPath.row)")
        default:
            print("Work incorrect")
        }
        
        
//        let text = textData[indexPath.section][indexPath.row]
//        let vc = FFCellSelectionViewController(titleText: text)
//        let navVC = FFNavigationController(rootViewController: vc)
//        navVC.modalPresentationStyle = .formSheet
//        navVC.sheetPresentationController?.detents = [.medium()]
//        navVC.sheetPresentationController?.prefersGrabberVisible = true
//        navVC.isNavigationBarHidden = false
//        viewController.present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 1 {
            return 55
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int,button: UIButton) -> UIView? {
        if section == tableView.numberOfSections - 1 {
            button.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 38)
            return button
        } else {
            return nil
        }
    }
    //Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let numberOfSections = tableView.numberOfSections
        let view = FFCreateHeaderView()
        let text = titleHeaderViewString[section]
        view.delegate = self
        view.configureHeaderView(section: section,numberOfSections: numberOfSections,text: text)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func alertController(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        alert.view.addSubview(picker)

        alert.view.snp.makeConstraints { make in
            make.height.equalTo(400)
        }
        
        picker.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(260)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancel)
        viewController.present(alert, animated: true)
    }
}

extension FFCreateProgramViewModel: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Index row is \(row) and component is \(component)"
    }
    
    
}

extension FFCreateProgramViewModel: AddSectionProtocol {
    func addSection() {
        let index = textData.count
        let indexDetailData = detailTextData.count
        detailTextData.insert(detailTextData[3], at: indexDetailData-1)
        titleHeaderViewString.insert("Exercise №\(index-3)", at: index-1)
        textData.insert(textData[3], at: index-1)
        tableView.insertSections(IndexSet(integer: index-1), with: .right)
        UIView.animate(withDuration: 1) { [unowned self] in
            tableView.reloadData()
        }
        
    }
    
    func removeSection() {
        let index = textData.count - 2
        let indexDetailData = detailTextData.count - 2
        textData.remove(at: index)
        detailTextData.remove(at: indexDetailData)
        titleHeaderViewString.remove(at: index)
        tableView.deleteSections(IndexSet(integer: index), with: .right)
        UIView.animate(withDuration: 1) { [unowned self] in
            tableView.reloadData()
        }
    }
    

}
