//
//  FFPlanDetailsViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 15.12.2023.
//

import UIKit

///Class for displaying previous created training plan and for some actions with these
class FFPlanDetailsViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFPlanDetailsViewModel!
    private var tableViewData = [String]()
    
    private let data: FFTrainingPlanRealmModel
    
    init(data: FFTrainingPlanRealmModel) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
        
        self.setupTableData(data: data)
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
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
    }
    
    func setupViewModel() {
        viewModel = FFPlanDetailsViewModel(viewController: self)
    }
    
    func setupNavigationController() {
        title = "Details"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
    }
    
    func setupTableData(data: FFTrainingPlanRealmModel){
        tableViewData.append("Name " + data.trainingName)
        tableViewData.append("Notes " + data.trainingNotes)
        tableViewData.append("Date: " + DateFormatter.localizedString(from: data.trainingDate, dateStyle: .medium, timeStyle: .short))
        tableViewData.append("Type: " + (data.trainingType ?? ""))
        tableViewData.append("Location: " + (data.trainingLocation ?? ""))
        tableViewData.append("Status - " + String(describing: data.trainingNotificationStatus))
        for exercise in data.trainingExercises {
            tableViewData.append("Exercise: " + exercise.exerciseName)
        }
    }
}

extension FFPlanDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        let data = tableViewData[indexPath.row]
        cell.textLabel?.text = data
        return cell
    }
}

extension FFPlanDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
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
