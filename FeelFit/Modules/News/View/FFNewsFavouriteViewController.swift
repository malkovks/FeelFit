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
    
    var viewModel: FFNewsFavouriteViewModel!

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "favouriteCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        loadingNewsModel()
        setupTableView()
        setupView()
    }
    
    private func setupView(){
        viewModel = FFNewsFavouriteViewModel()
        title = "Favourites"
        view.setNeedsDisplay()
        contentUnavailableConfiguration = viewModel.isViewConfigurationAvailable(model: newsModels)
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadingNewsModel(){
//        newsModels = viewModel.loadData()
        let realm = try! Realm()
        let model = realm.objects(FFNewsModelRealm.self)
        newsModels = model
        tableView.reloadData()
    }
}

extension FFNewsFavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "favouriteCell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = newsModels[indexPath.row].newsTitle
        cell.detailTextLabel?.text = newsModels[indexPath.row].newsContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = viewModel.didSelectRow(at: indexPath, newsModels: newsModels)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        view.setNeedsDisplay()
        return viewModel?.setupDeletingNews(tableView: tableView,indexPath: indexPath, newsModels: newsModels)
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

#Preview {
    FFNewsFavouriteViewController()
}
