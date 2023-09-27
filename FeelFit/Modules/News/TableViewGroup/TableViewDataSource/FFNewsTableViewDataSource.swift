//
//  FFNewsTableViewDataSource.swift
//  FeelFit
//
//  Created by Константин Малков on 26.09.2023.
//

import UIKit

class FFNewsTableViewDataSource: NSObject, UITableViewDataSource, TableViewCellDelegate {
    
//    var cellDataModel: [Articles] = [Articles(source: Source.init(name: "Some name"), title: "Some title", description: "some description", url: "Some url", urlToImage: nil, publishedAt: "Published at", author: "Some authir", content: "Some content")]
//    
    var cellDataModel = [Articles]()
    init(with cellDataModel: [Articles] = [Articles]()) {
        self.cellDataModel = cellDataModel
        super.init()
    }
//    init(cellDataModel: [Articles]? = nil) {
//        self.cellDataModel = cellDataModel!
//        super.init()
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsPageTableViewCell.identifier, for: indexPath) as! NewsPageTableViewCell
        let data = cellDataModel[indexPath.row]
        cell.configureCell(model: data)
        cell.delegate = self
        return cell
    }
    
    
    
    func buttonDidTapped(sender: UITableViewCell,status: Bool) {
        if status {
            print("Added to favourite")
        } else {
            print("Removed from favourite")
        }
    }
    
}
