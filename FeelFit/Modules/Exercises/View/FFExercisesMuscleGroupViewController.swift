//
//  FFExercisesMuscleGroupViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 31.10.2023.
//

import UIKit

class FFExercisesMuscleGroupViewController: UIViewController,SetupViewController {
    
    var viewModel: FFExerciseMuscleGroupViewModel!
    
    var muscleExercises = [Exercises]()
    var muscleGroupName: String
    
    init(muscleGroupName: String){
        self.muscleGroupName = muscleGroupName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tableView: UITableView!
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = FFResources.Colors.activeColor
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupTableView()
        setupConstraints()
        setupView()
    }
    
    
    
    func setupView() {
        view.backgroundColor = .lightGray
        viewModel = FFExerciseMuscleGroupViewModel()
        viewModel.delegate = self
        viewModel.loadData(name: muscleGroupName)
    }
    
    func setupNavigationController() {
        title = "Exercises on muscles"
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    
}

extension FFExercisesMuscleGroupViewController: FFExerciseProtocol {
    func viewWillLoadData() {
        spinner.startAnimating()
    }
    
    func viewDidLoadData(result: Result<[Exercises], Error>) {
        switch result {
        case .success(let model):
            self.muscleExercises = model
            self.tableView.reloadData()
        case .failure(let error):
            alertError(title: "Error",message: error.localizedDescription)
        }
        spinner.stopAnimating()
    }
    
    
    
    
}

extension FFExercisesMuscleGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        muscleExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let exercise = muscleExercises[indexPath.row]
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = "Difficult - " + exercise.difficulty
        cell.accessoryType = .disclosureIndicator
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true
        return cell
    }
}

extension FFExercisesMuscleGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(tableView, indexPath: indexPath, viewController: self, model: muscleExercises)
    }
}


extension FFExercisesMuscleGroupViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(spinner)
        spinner.center = view.center
    }
}
