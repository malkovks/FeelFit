//
//  FFNewsTableViewDataSource.swift
//  FeelFit
//
//  Created by Константин Малков on 26.09.2023.
//

import UIKit

class FFNewsTableViewDataSource: NSObject, UITableViewDataSource, TableViewCellDelegate {
    
    var cellDataModel: [Articles]?
    
    init(cellDataModel: [Articles]? = nil) {
        self.cellDataModel = cellDataModel
        super.init()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataModel?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsPageTableViewCell.identifier, for: indexPath) as! NewsPageTableViewCell
        let data = cellDataModel?[indexPath.row]
        cell.configureCell(model: data)
        cell.delegate = self
        return cell
    }
    
    func buttonDidTapped(sender: UITableViewCell) {
        print("Added to favourite")
    }
    
}
