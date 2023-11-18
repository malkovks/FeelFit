//
//  FFExercisesMuscleGroupViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 31.10.2023.
//

import UIKit

class FFExercisesMuscleGroupViewController: UIViewController,SetupViewController {
    
    var viewModel: FFExerciseMuscleGroupViewModel!
    
    var muscleExercises = [Exercise]()
    var muscleGroupName: String
    
    init(muscleGroupName: String){
        self.muscleGroupName = muscleGroupName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var refreshController: UIRefreshControl = {
       let refresh = UIRefreshControl()
        refresh.tintColor = FFResources.Colors.activeColor
        return refresh
    }()
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
    
    @objc private func didTapRefreshPage(){
        viewModel.loadData(name: muscleGroupName)
    }
    
    
    func setupView() {
        view.backgroundColor = .lightGray
        viewModel = FFExerciseMuscleGroupViewModel()
        viewModel.delegate = self
        viewModel.loadData(name: muscleGroupName)
    }
    
    func setupNavigationController() {
        let value = muscleExercises.first?.muscle.capitalized
        title = value
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(FFExercisesMuscleTableViewCell.self, forCellReuseIdentifier: FFExercisesMuscleTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
        tableView.tableFooterView = nil
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(didTapRefreshPage), for: .valueChanged)
    }
 
    
}

extension FFExercisesMuscleGroupViewController: FFExerciseProtocol {
    func viewWillLoadData() {
        spinner.startAnimating()
    }
    
    func viewDidLoadData(result: Result<[Exercise], Error>) {
        switch result {
        case .success(let model):
            self.muscleExercises = model
            self.tableView.reloadData()
        case .failure(let error):
            alertError(title: "Error",message: error.localizedDescription)
        }
        refreshController.endRefreshing()
        spinner.stopAnimating()
    }
    
}

extension FFExercisesMuscleGroupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        muscleExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFExercisesMuscleTableViewCell.identifier, for: indexPath) as! FFExercisesMuscleTableViewCell
        let exercise = muscleExercises[indexPath.row]
        cell.indexPath = indexPath
        cell.configureView(keyName: muscleGroupName, exercise: exercise,indexPath: indexPath)
        
        return cell
    }
}

extension FFExercisesMuscleGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
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

extension FFExercisesMuscleGroupViewController {
    func mockModelTest() -> [Exercise] {
        let model = [
            Exercise(bodyPart: "Biceps", equipment: "barbell", imageLink: "", exerciseID: "9999", exerciseName: "The ExerciseDB gives you access to over 1300 exercises with individual exercise data and animated de", muscle: "biceps", secondaryMuscles: [""], instructions: [""]),
            Exercise(bodyPart: "Biceps", equipment: "barbell", imageLink: "", exerciseID: "0001", exerciseName: "Pull Up", muscle: "biceps", secondaryMuscles: [""], instructions: [""]),
            Exercise(bodyPart: "Biceps", equipment: "barbell", imageLink: "", exerciseID: "1234", exerciseName: "Pull Up", muscle: "biceps", secondaryMuscles: [""], instructions: [""]),
            Exercise(bodyPart: "Biceps", equipment: "barbell", imageLink: "", exerciseID: "0021", exerciseName: "Pull Up", muscle: "biceps", secondaryMuscles: [""], instructions: [""]),
            Exercise(bodyPart: "Biceps", equipment: "barbell", imageLink: "", exerciseID: "0301", exerciseName: "Pull Up", muscle: "biceps", secondaryMuscles: [""], instructions: [""]),
        ]
        return model
    }
}
