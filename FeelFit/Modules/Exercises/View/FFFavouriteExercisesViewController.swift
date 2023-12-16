//
//  FFFavouriteExercisesViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 16.11.2023.
//

import UIKit
import RealmSwift

class FFFavouriteExercisesViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFFavouriteExerciseViewModel!
    
    private var tableView: UITableView!
    
    private var model: Results<FFFavouriteExerciseRealmModel>!
    private var sortedModel = [String: [FFFavouriteExerciseRealmModel]]()
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExercisesData()
        setupView()
        setupTableView()
        setupViewModel()
        setupNavigationController()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadExercisesData()
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
        
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.darkPurple
        if model.count > 0 {
            setupConstraints()
            contentUnavailableConfiguration = nil
        } else {
            var config = UIContentUnavailableConfiguration.empty()
            config.text = "No favourite exercises"
            config.secondaryText = "Add it by selecting muscles modules"
            config.image = UIImage(systemName: "heart.fill")
            config.image?.withTintColor(FFResources.Colors.activeColor)
            contentUnavailableConfiguration = config
        }
    }
    
    func setupViewModel(){
        viewModel = FFFavouriteExerciseViewModel(viewController: self)
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
        model = realm.objects(FFFavouriteExerciseRealmModel.self)
        for m in model {
            let muscle = realm.objects(FFFavouriteExerciseRealmModel.self).filter("exerciseMuscle == %@", m.exerciseMuscle)
            sortedModel[m.exerciseMuscle] = Array(muscle)
        }
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
        let name = data?.exerciseName.capitalized
        cell.textLabel?.text = name
        return cell
    }
}

extension FFFavouriteExercisesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableView(tableView, didSelectRowAt: indexPath, sortedModel: sortedModel)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let key = Array(sortedModel.keys.sorted())[indexPath.section]
        let values = sortedModel[key]
        let value = values![indexPath.row]
        let deleteInstance = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            tableView.beginUpdates()
            FFFavouriteExerciseStoreManager.shared.clearExerciseWith(realmModel: value)
            self?.sortedModel[key]?.remove(at: indexPath.row)
            if let updatedArray = self?.sortedModel[key] {
                self?.sortedModel[key] = updatedArray
            } else {
                self?.sortedModel.removeValue(forKey: key)
            }

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
