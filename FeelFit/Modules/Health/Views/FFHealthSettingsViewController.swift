//
//  FFHealthSettingsViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 15.02.2024.
//

import UIKit

class FFHealthSettingsViewController: UIViewController, SetupViewController {
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    

    func setupView() {
        view.backgroundColor = .darkGray
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupConstraints()
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
        tableView.backgroundColor = .clear
        
    }
    
    func setupNavigationController() {
        title = "Settings"
    }
    
    func setupViewModel() {
        
    }

}

extension FFHealthSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        cell.textLabel?.text = "Text label rows is \(indexPath.row)"
        cell.backgroundColor = .systemBackground
        return cell
    }
}

extension FFHealthSettingsViewController: UITableViewDelegate {
    
}

private extension FFHealthSettingsViewController {
    func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
