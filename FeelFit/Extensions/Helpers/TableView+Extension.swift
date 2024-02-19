//
//  TableView+Extension.swift
//  FeelFit
//
//  Created by Константин Малков on 30.01.2024.
//

import UIKit

extension UITableView {
    func setupAppearanceShadow(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
    }
}
