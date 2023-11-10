//
//  FFNewsTableViewDataSource.swift
//  FeelFit
//
//  Created by Константин Малков on 26.09.2023.
//

import UIKit

///Custom News Table View Data Source class for optimization code
class FFNewsTableViewDataSource: NSObject, UITableViewDataSource, TableViewCellDelegate {
  
    var cellDataModel = [Articles]()
    var viewController: UIViewController
    init(with cellDataModel: [Articles] = [Articles](), viewController: UIViewController) {
        self.cellDataModel = cellDataModel
        self.viewController = viewController
        super.init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFNewsPageTableViewCell.identifier, for: indexPath) as! FFNewsPageTableViewCell
        let data = cellDataModel[indexPath.row]
        cell.configureCell(model: data,indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func buttonDidTapped(sender: UITableViewCell,indexPath: IndexPath,status: Bool) {
        let model = cellDataModel[indexPath.row]
        if status {
            viewController.viewAlertController(text: "Added to Favourite", startDuration: 0.5, timer: 1.5, controllerView: viewController.view)
            FFNewsStoreManager.shared.saveNewsModel(model: model, status: status)
        } else {
            viewController.viewAlertController(text: "Removed from Favourite", startDuration: 0.5, timer: 1.5, controllerView: viewController.view)
            FFNewsStoreManager.shared.deleteNewsModel(model: model, status: status)
        }
    }
    
}
