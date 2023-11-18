//
//  FFFavouriteExercisesViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 16.11.2023.
//

import UIKit
import RealmSwift

class FFFavouriteExercisesViewController: UIViewController, SetupViewController {
    
    private var tableView: UITableView!
    
    private var model: Results<FFExerciseModelRealm>!
    private var sortedModel = [String: [FFExerciseModelRealm]]()
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExercisesData()
        setupView()
        setupTableView()
        setupNavigationController()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.darkPurple
    }
    
    func setupNavigationController() {
        title = "Favourites"
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadExercisesData(){
        model = realm.objects(FFExerciseModelRealm.self)
        for m in model {
            let muscle = realm.objects(FFExerciseModelRealm.self).filter("exerciseMuscle == %@", m.exerciseMuscle)
            sortedModel[m.exerciseMuscle] = Array(muscle)
        }
    }
    
    func clearData(){
        sortedModel.removeAll()
        loadExercisesData()
        tableView.reloadData()
    }
}

extension FFFavouriteExercisesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedModel.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group = Array(sortedModel.keys.sorted())[section].formatArrayText()
        return group
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = Array(sortedModel.keys.sorted())[section]
        return sortedModel[group]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        let key = Array(sortedModel.keys.sorted())[indexPath.section]
        let value = sortedModel[key]
        let data = value?[indexPath.row]
        
        cell.textLabel?.text = data?.exerciseName
        return cell
    }
    
    
}

extension FFFavouriteExercisesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = Array(sortedModel.keys.sorted())[indexPath.section]
        let values = sortedModel[key]
        let value = values![indexPath.row]
        let model = Exercise(bodyPart: value.exerciseBodyPart, equipment: value.exerciseEquipment, imageLink: value.exerciseImageLink, exerciseID: value.exerciseID, exerciseName: value.exerciseName, muscle: value.exerciseMuscle, secondaryMuscles: [value.exerciseSecondaryMuscles], instructions: [value.exerciseInstructions])
        let vc = FFExerciseDescriptionViewController(exercise: model)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let key = Array(sortedModel.keys.sorted())[indexPath.section]
        let values = sortedModel[key]
        let value = values![indexPath.row]
        let deleteInstance = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            tableView.beginUpdates()
            FFFavouriteExerciseStoreManager.shared.clearExerciseWith(realmModel: value)
//            self?.clearData()
            tableView.deleteRows(at: [indexPath], with: .top)
            
            tableView.endUpdates()
        }
        deleteInstance.backgroundColor = UIColor.systemRed
        deleteInstance.image = UIImage(systemName: "trash.fill")?
            .withTintColor(.clear)
        return UISwipeActionsConfiguration(actions: [deleteInstance])
    }
}

extension FFFavouriteExercisesViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
