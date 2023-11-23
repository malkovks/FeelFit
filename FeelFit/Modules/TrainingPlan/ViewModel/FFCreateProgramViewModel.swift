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

protocol ButtonMenuPressed: AnyObject {
    func menuDidSelected(text: String,_ indexPath: IndexPath)
}

class FFCreateProgramViewModel {
    
    
    weak var delegate: ButtonMenuPressed?
    
    var textData = [
        ["Name Of Workout"],
        ["Duration","Location","Type","Training Date"],
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
    
    func chosenMenuType(_ type: ButtonTypeMenu,_ indexPath: IndexPath) -> UIMenu {
        switch type {
        case .duration:
            return durationTypeMenu(indexPath)
        case .location:
            return locationTypeMenu(indexPath)
        case .trainingType:
            return trainingTypeMenu(indexPath)
        }
    }
    
    private func durationTypeMenu(_ indexPath: IndexPath) -> UIMenu{
        var actions: [UIAction] {
            [UIAction(title: "5 minutes", handler: { _ in
                self.delegate?.menuDidSelected(text: "5 minutes", indexPath)
            }),
             UIAction(title: "10 minutes", handler: { _ in
                self.delegate?.menuDidSelected(text: "10 minutes", indexPath)
            }),
             UIAction(title: "15 minutes", handler: { _ in
                self.delegate?.menuDidSelected(text: "15 minutes", indexPath)
            }),
             UIAction(title: "30 minutes", handler: { _ in
                self.delegate?.menuDidSelected(text: "30 minutes", indexPath)
            }),
             UIAction(title: "60 minutes", handler: { _ in
                self.delegate?.menuDidSelected(text: "60 minutes", indexPath)
            }),
             UIAction(title: "90 minutes", handler: { _ in
                self.delegate?.menuDidSelected(text: "90 minutes", indexPath)
            }),
             UIAction(title: "120 minutes", handler: { _ in
                self.delegate?.menuDidSelected(text: "120 minutes", indexPath)
            })
            ]
        }
        let menu = UIMenu(children: actions)
        return menu
    }
    
    private func locationTypeMenu(_ indexPath: IndexPath) -> UIMenu{
        var actions: [UIAction] {
            [UIAction(title: "Outside", handler: { _ in
                self.delegate?.menuDidSelected(text: "Outside", indexPath)
            }),
             UIAction(title: "Inside", handler: { _ in
                self.delegate?.menuDidSelected(text: "Inside", indexPath)
            })
            ]
        }
        var menu = UIMenu(children: actions)
        return menu
    }
    
    private func trainingTypeMenu(_ indexPath: IndexPath) -> UIMenu{
        var actions: [UIAction] {
            [UIAction(title: "Cardio", handler: { _ in
                self.delegate?.menuDidSelected(text: "Cardio", indexPath)
            }),
             UIAction(title: "Strength", handler: { _ in
                self.delegate?.menuDidSelected(text: "Strength", indexPath)
            }),
             UIAction(title: "Endurance", handler: { _ in
                self.delegate?.menuDidSelected(text: "Endurance", indexPath)
            }),
             UIAction(title: "Flexibility", handler: { _ in
                self.delegate?.menuDidSelected(text: "Flexibility", indexPath)
            }),
            ]
        }
        var menu = UIMenu(children: actions)
        return menu
    }
    
    
    @objc private func didTapPress(sender: IndexPath){
        print(sender.row)
    }
    
    //MARK: - TableViewData Source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFCreateTableViewCell.identifier, for: indexPath) as! FFCreateTableViewCell
        cell.configureTableViewCell(tableView: tableView, indexPath: indexPath, text: textData, actionLabel: detailTextData)
        return cell
    }
    
    //TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let text = textData[indexPath.section][indexPath.row]
        let vc = FFCellSelectionViewController(titleText: text)
        let navVC = FFNavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .formSheet
        navVC.sheetPresentationController?.detents = [.medium()]
        navVC.sheetPresentationController?.prefersGrabberVisible = true
        navVC.isNavigationBarHidden = false
        viewController.present(navVC, animated: true)
    }
    //MARK: - Did select & height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    //Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 1{
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
    //MARK: - Header
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
