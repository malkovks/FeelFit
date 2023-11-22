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
    
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func setupSectionsValue() {
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
