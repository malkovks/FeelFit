//
//  FFAccessToServicesViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 28.04.2024.
//

import UIKit

class FFAccessToServicesViewController: UIViewController {
    
    private let cellIdentifier = "accessCell"
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,style: .insetGrouped)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private var viewModel: FFAccessToServicesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

extension FFAccessToServicesViewController: SetupViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        title = "Access to services"
        setupViewModel()
        setupNavigationController()
        setupTableView()
        requestAccess()
        setupConstraints()
    }
    
    func setupViewModel() {
        viewModel = FFAccessToServicesViewModel(viewController: self)
        
    }
    
    func setupNavigationController() {
        
    }
    
    private func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func requestAccess() {
        Task {
            let services = CheckServiceAuthentication()
            let value = await services.checkAccess()
            dump(value)
        }
        
    }
}

extension FFAccessToServicesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = "Number of rows equal to \(indexPath.row)"
        return cell
    }
}

extension FFAccessToServicesViewController: UITableViewDelegate {
    
}

extension FFAccessToServicesViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
