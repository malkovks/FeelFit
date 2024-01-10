//
//  FFPlanDetailsViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 15.12.2023.
//

import UIKit
import RealmSwift


///Class for displaying previous created training plan and for some actions with these
class FFPlanDetailsViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFPlanDetailsViewModel!
    
    private var numberOfRows: Int = 0
    private let data: FFTrainingPlanRealmModel
    private var isTableViewEditing: Bool = false
    private var tableCount = 7
    
    init(data: FFTrainingPlanRealmModel) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupViewModel()
        setupNavigationController()
        setupTableView()
        setupConstraints()
    }
    
    @objc private func didTapDismiss(){
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapEditTraining() {
        viewModel.didTapEditTraining(data)
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
    }
    
    func setupViewModel() {
        viewModel = FFPlanDetailsViewModel(viewController: self)
    }
    
    func setupNavigationController() {
        title = "Details"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "Back", imageName: "", action: #selector(didTapDismiss), menu: nil)
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Edit", imageName: "", action: #selector(didTapEditTraining), menu: nil)
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero,style: .plain)
        tableView.register(FFPlanDetailTableViewCell.self, forCellReuseIdentifier: FFPlanDetailTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = true
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
}

extension FFPlanDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFPlanDetailTableViewCell.identifier, for: indexPath) as! FFPlanDetailTableViewCell
        cell.configureCell(data, indexPath: indexPath, isTableViewEditing)
        return cell
    }
}

extension FFPlanDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, estimatedHeightForRowAt: indexPath)
    }
}

extension FFPlanDetailsViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
