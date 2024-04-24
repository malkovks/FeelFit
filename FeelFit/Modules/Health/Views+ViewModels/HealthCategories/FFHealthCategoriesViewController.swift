//
//  FFHealthCategoriesViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 10.02.2024.
//

import UIKit

/// Class displaying table view with all accessed Quantity Type Identifiers and give to user possibility for filter collection view
class FFHealthCategoriesViewController: UIViewController, SetupViewController {
    
    var isViewDismissed: (() -> ())?
    
    private let sharedIdentifiers = FFHealthData.allQuantityTypeIdentifiers
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func didTapSave(){
        self.isViewDismissed?()
        self.dismiss(animated: true)
    }
    
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupConstraints()
    }
    
    func setupNavigationController() {
        title = "Edit Favourites"
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Done", imageName: "", action: #selector(didTapSave), menu: nil)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupViewModel() {
        
    }
    
    private func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FFFavouriteHealthDataTableViewCell.self, forCellReuseIdentifier: FFFavouriteHealthDataTableViewCell.identifier)
        tableView.layer.cornerRadius = 12
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .clear
    }
    
    
}

extension FFHealthCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: FFFavouriteHealthDataTableViewCell.identifier, for: indexPath) as! FFFavouriteHealthDataTableViewCell
        cell.configureCell(indexPath,identifier: sharedIdentifiers)
        return cell
    }
}

extension FFHealthCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! FFFavouriteHealthDataTableViewCell
        cell.didTapChangeStatus()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

private extension FFHealthCategoriesViewController {
    func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
