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
    var sortedExercises: [[Exercises]] = []
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
        sortArray()
    }
    
    func sortArray(){
        let sortedType = muscleExercises.sorted { $0.type < $1.type }
        
        var currentType = sortedType.first?.type
        var currentSection = [Exercises]()
        for type in sortedType {
            if type.type == currentType {
                currentSection.append(type)
            } else {
                sortedExercises.append(currentSection)
                currentSection = [type]
                currentType = type.type
            }
        }
        
        sortedExercises.append(currentSection)
        tableView.reloadData()
    }
    
    
    func setupView() {
        view.backgroundColor = .lightGray
        viewModel = FFExerciseMuscleGroupViewModel()
        viewModel.delegate = self
        viewModel.loadData(name: muscleGroupName)
    }
    
    func setupNavigationController() {
        let value = muscleExercises.first?.name.capitalized
        title = value
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
        tableView.tableFooterView = nil
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
            self.sortArray()
            self.tableView.reloadData()
        case .failure(let error):
            alertError(title: "Error",message: error.localizedDescription)
        }
        spinner.stopAnimating()
    }
    
}

extension FFExercisesMuscleGroupViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedExercises.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedExercises[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let exercise = sortedExercises[indexPath.section][indexPath.row]
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = "Equipment - " + exercise.equipment.formatArrayText()
        cell.accessoryType = .disclosureIndicator
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let type = sortedExercises[section].first?.type
        let fixedType = (type?.formatArrayText() ?? "") 
        return fixedType
    }
}

extension FFExercisesMuscleGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRowAt(tableView, indexPath: indexPath, viewController: self, model: sortedExercises)
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
