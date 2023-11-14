//
//  FFCreateProgramViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 13.11.2023.
//

import UIKit

class FFCreateProgramViewModel {
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func setupSectionsValue() {
        
    }
    
    func pressSettingMenu() -> UIMenu{
        var actions: [UIAction] {
            [UIAction(title: "5 minutes", handler: { _ in
                
            }),
             UIAction(title: "10 minutes", handler: { _ in
                
            }),
             UIAction(title: "15 minutes", handler: { _ in
                
            }),
             UIAction(title: "30 minutes", handler: { _ in
                
            }),
            ]
        }
        var menu = UIMenu(children: actions)
        return menu
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)!
        let menu = pressSettingMenu()
        let menuController = UIMenuController.shared
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
