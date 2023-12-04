//
//  FFMuscleGroupTableViewDataSource.swift
//  FeelFit
//
//  Created by Константин Малков on 04.12.2023.
//

import UIKit

class FFMuscleGroupTableViewDataSource: NSObject, UITableViewDataSource {
    
    var data: [String: String]
    var viewController: UIViewController!
    
    init(data: [String : String], viewController: UIViewController!) {
        self.data = data
        self.viewController = viewController
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFMuscleGroupTableViewCell.identifier, for: indexPath) as! FFMuscleGroupTableViewCell
        cell.configureCell(indexPath: indexPath, data: data)
        return cell
    }
}
