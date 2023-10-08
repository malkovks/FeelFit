//
//  FFNewsFavouriteViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 04.10.2023.
//

import UIKit
import RealmSwift


///Class for displaying stored news which was added to favourite
class FFNewsFavouriteViewController: UIViewController {
    
    var newsModels: Results<FFNewsModelRealm>!
    var localRealm = try! Realm()

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "favouriteCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupConstraints()
        loadingNewsModel()
        title = "Favourites"
    }
    
    private func loadingNewsModel(){
        let value = localRealm.objects(FFNewsModelRealm.self)
        newsModels = value
        tableView.reloadData()
    }
    private func setupDeletingNews(tableView: UITableView,indexPath: IndexPath) -> UISwipeActionsConfiguration{
        let model = newsModels[indexPath.row]
        let deleteInstance = UIContextualAction(style: .destructive, title: "") { _, _, _ in
            tableView.beginUpdates()
            FFNewsStoreManager.shared.deleteNewsModelRealm(model: model)
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
        }
        deleteInstance.backgroundColor = .systemRed
        deleteInstance.image = UIImage(systemName: "trash.fill")
        deleteInstance.image?.withTintColor(.systemBackground)
        let action = UISwipeActionsConfiguration(actions: [deleteInstance])
        return action
    }

}

extension FFNewsFavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "favouriteCell")
        cell.textLabel?.text = newsModels[indexPath.row].newsTitle
        cell.detailTextLabel?.text = newsModels[indexPath.row].newsContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newModel = newsModels[indexPath.row]
        let convertedModel = Articles.convertRealmModel(model: newModel)
        let vc = FFNewsPageDetailViewController(model: convertedModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        setupDeletingNews(tableView: tableView,indexPath: indexPath)
    }
}

extension FFNewsFavouriteViewController{
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
