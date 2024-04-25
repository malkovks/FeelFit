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
    
    private var viewModel: FFHealthCategoriesViewModel!
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func didTapSave(){
        isViewDismissed?()
        viewModel.saveSelectedCategories()
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
        viewModel = FFHealthCategoriesViewModel(viewController: self)
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
        viewModel.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        viewModel.tableView(tableView, cellForRowAt: indexPath)
    }
}

extension FFHealthCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
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
