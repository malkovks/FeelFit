//
//  FFExercisesMuscleGroupViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 31.10.2023.
//

import UIKit

class FFExercisesMuscleGroupViewController: UIViewController,SetupViewController {
    
    var muscleExercises = [Exercises]()
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupTableView()
        setupConstraints()
    }
    
    func loadData(name: String){
        FFGetExerciseRequest.shared.getRequest(muscleName: name) { result in
            switch result {
            case .success(let success):
                self.muscleExercises = success
                self.tableView.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func setupView() {
        view.backgroundColor = .lightGray
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

extension FFExercisesMuscleGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        muscleExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let exercise = muscleExercises[indexPath.row]
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = exercise.instructions
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true
        return cell
    }
}

extension FFExercisesMuscleGroupViewController: UITableViewDelegate {
    
}


extension FFExercisesMuscleGroupViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
