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
        var cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
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
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return view.frame.size.height/2
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let exercise = muscleExercises[indexPath.row]
        let vc = FFExerciseDescriptionViewController(exercise: exercise)
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension FFExercisesMuscleGroupViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
