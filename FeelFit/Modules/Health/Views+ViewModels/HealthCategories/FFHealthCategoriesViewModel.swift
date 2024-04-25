//
//  FFHealthCategoriesViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 24.04.2024.
//

import UIKit

class FFHealthCategoriesViewModel {
    
    private let sharedIdentifiers = FFHealthData.allQuantityTypeIdentifiers
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func saveSelectedCategories(){
        viewController.dismiss(animated: true)
    }
}

//MARK: - Table view data source
extension FFHealthCategoriesViewModel {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFFavouriteHealthDataTableViewCell.identifier, for: indexPath) as! FFFavouriteHealthDataTableViewCell
        cell.configureCell(indexPath,identifier: sharedIdentifiers)
        return cell
    }
}

//MARK: - Table view delegate
extension FFHealthCategoriesViewModel {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! FFFavouriteHealthDataTableViewCell
        cell.didTapChangeStatus()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
