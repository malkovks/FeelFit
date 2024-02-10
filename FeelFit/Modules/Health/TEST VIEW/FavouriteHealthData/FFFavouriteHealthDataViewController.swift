//
//  FFFavouriteHealthDataViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 10.02.2024.
//

import UIKit

class FFFavouriteHealthDataViewController: UIViewController, SetupViewController {
    
    private let sharedIdentifiers = FFHealthData.allQuantityTypeIdentifiers
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func didTapSave(){
        print("Settings saved")
        self.dismiss(animated: true)
    }
    
    @objc private func didTapAddFavourite(_ sender: UIButton){
        if sender.isSelected {
            
        }
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

extension FFFavouriteHealthDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let button = UIButton(type: .custom)
//        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        button.setImage(UIImage(systemName: "star"), for: .normal)
//        button.tintColor = FFResources.Colors.darkPurple
//        button.backgroundColor = .clear
//        button.addTarget(self, action: #selector(didTapAddFavourite), for: .primaryActionTriggered)
//        
        let cell = tableView.dequeueReusableCell(withIdentifier: FFFavouriteHealthDataTableViewCell.identifier, for: indexPath) as! FFFavouriteHealthDataTableViewCell
        cell.configureCell(indexPath, sharedIdentifiers, false)
//        let type = sharedIdentifiers[indexPath.row]
//        let text = getDataTypeName(type)
//        cell.textLabel?.text = text
//        cell.backgroundColor = .systemBackground
//        cell.accessoryView = button
        return cell
    }
}

extension FFFavouriteHealthDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

private extension FFFavouriteHealthDataViewController {
    func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
