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
    
    private let data: FFTrainingPlanRealmModel
    
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
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(FFPlanDetailTableViewCell.self, forCellReuseIdentifier: FFPlanDetailTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
    }
}

extension FFPlanDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6+data.trainingExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFPlanDetailTableViewCell.identifier, for: indexPath) as! FFPlanDetailTableViewCell
        cell.configureCell(data, indexPath: indexPath)
        return cell
    }
    
}

extension FFPlanDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/2
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
