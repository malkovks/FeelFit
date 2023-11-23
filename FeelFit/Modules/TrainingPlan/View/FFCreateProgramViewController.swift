//
//  FFCreateProgramViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 09.11.2023.
//

import UIKit




class FFCreateProgramViewController: UIViewController, SetupViewController {
    
    var viewModel: FFCreateProgramViewModel!
    
    
    
    private let closeFooterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 14
        button.tintColor = FFResources.Colors.activeColor
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableViewAndViewModel()
        
        
        
        setupNavigationController()
        setupConstraints()
    }
    
    @objc private func buttonTapped(){
        self.dismiss(animated: true)
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Save", imageName: "", action: #selector(buttonTapped), menu: nil)
    }
    
    func setupNavigationController() {
        title = "Create new plan"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupTableViewAndViewModel(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        viewModel = FFCreateProgramViewModel(viewController: self, tableView: tableView)
        
        tableView.register(FFCreateTableViewCell.self, forCellReuseIdentifier: FFCreateTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = FFResources.Colors.tabBarBackgroundColor
        tableView.sectionIndexColor = .orange
        tableView.tableFooterView = nil
        closeFooterButton.addTarget(self, action: #selector(buttonTapped), for: .primaryActionTriggered)
    }
}

extension FFCreateProgramViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.textData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.textData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.tableView(tableView, cellForRowAt: indexPath)
    }
}

extension FFCreateProgramViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableView(tableView, didSelectRowAt: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
    //MARK: - Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        viewModel.tableView(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.tableView(tableView, heightForHeaderInSection: section)
    }
    //MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        viewModel.tableView(tableView, heightForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        viewModel.tableView(tableView, viewForFooterInSection: section, button: closeFooterButton)
    }
}

extension FFCreateProgramViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
