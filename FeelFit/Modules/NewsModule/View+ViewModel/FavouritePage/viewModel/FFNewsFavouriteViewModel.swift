//
//  FFNewsFavouriteViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 16.10.2023.
//

import UIKit
import RealmSwift

class FFNewsFavouriteViewModel {
    
    var realm = try! Realm()
    
    
    /// Loading favourite news from database
    /// - Returns: return loaded data
    func loadData() -> Results<FFNewsModelRealm>? {
        let model = realm.objects(FFNewsModelRealm.self)
        return model
    }
    
    /// Setup delete row for table view
    /// - Parameters:
    ///   - tableView: table view
    ///   - indexPath: index path of selected row
    ///   - newsModels: realm model
    /// - Returns: return configuration
    func setupDeletingNews(tableView: UITableView,indexPath: IndexPath, newsModels: Results<FFNewsModelRealm>) -> UISwipeActionsConfiguration{
        let model = newsModels[indexPath.row]
        let deleteInstance = UIContextualAction(style: .destructive, title: "") { _, _, _ in
            tableView.beginUpdates()
            FFNewsStoreManager.shared.deleteNewsModelRealm(model: model)
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
        }
        deleteInstance.backgroundColor = UIColor.systemRed
        deleteInstance.image = UIImage(systemName: "trash.fill")
        deleteInstance.image?.withTintColor(UIColor.systemBackground)
        let action = UISwipeActionsConfiguration(actions: [deleteInstance])
        return action
    }
    
    
    /// Function for action when user tap on cell
    /// - Parameters:
    ///   - indexPath: index path of table view
    ///   - newsModels: realm array
    /// - Returns: return viewController which will present next
    func didSelectRow(at indexPath: IndexPath, newsModels: Results<FFNewsModelRealm>) -> FFNewsPageDetailViewController {
        let newModel = newsModels[indexPath.row]
        let convertedModel = Articles.convertRealmModel(model: newModel)
        let vc = FFNewsPageDetailViewController(model: convertedModel)
        return vc
    }
    
    /// Func for setup configuration view if its empty
    /// - Parameter model: realm model
    /// - Returns: return configuration for view(optional)
    func isViewConfigurationAvailable(model: Results<FFNewsModelRealm>) -> UIContentUnavailableConfiguration? {
        if model.isEmpty {
            var config = UIContentUnavailableConfiguration.empty()
            config.text = "No favourite news"
            config.image = UIImage(systemName: "heart")
            config.secondaryText = "Add any news by clicking on 'Heart' and it will display in this list"
            return config
        } else {
            return nil
        }
    }
}
