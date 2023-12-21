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
    private var isTableViewEditing: Bool = false
    
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
    
    @objc private func didTapEditTraining() {
        let trainPlan = CreateTrainProgram(name: data.trainingName,
                                           note: data.trainingNotes,
                                           type: data.trainingType,
                                           location: data.trainingType,
                                           date: data.trainingDate,
                                           notificationStatus: data.trainingNotificationStatus)
        let vc = FFCreateTrainProgramViewController(isViewEdited: true, trainPlanData: trainPlan)
        
        navigationController?.pushViewController(vc, animated: true)
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
    }
}

extension FFPlanDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFPlanDetailTableViewCell.identifier, for: indexPath) as! FFPlanDetailTableViewCell
        cell.configureCell(data, indexPath: indexPath, isTableViewEditing)
        return cell
    }
}

extension FFPlanDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1, 6:
            return UITableView.automaticDimension
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 6:
            let program = CreateTrainProgram(name: data.trainingName, note: data.trainingNotes,type: data.trainingType ?? "Default", location: data.trainingLocation, date: data.trainingDate, notificationStatus: data.trainingNotificationStatus)
            let vc = FFAddExerciseViewController(trainProgram: program)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
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
