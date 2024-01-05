//
//  FFPlanCompletedTrainingViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 29.12.2023.
//

import UIKit
import RealmSwift

class FFPlanCompletedTrainingViewController: UIViewController, SetupViewController {
    
    private var tableView: UITableView!
    private var viewModel: FFPlanCompletedTrainingViewModel!
    private var timer: Timer?
    
    private var completedPlans: [FFTrainingPlanRealmModel]!
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRealmData()
        setupView()
        setupViewModel()
        setupNavigationController()
        setupTableView()
        setupConstraints()
        
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
        
        if completedPlans.isEmpty {
            contentUnavailableConfiguration = viewModel.configUnavailableView()
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    func setupNavigationController() {
        title = "Completed"
    }
    
    func setupViewModel() {
        viewModel = FFPlanCompletedTrainingViewModel(viewController: self)
    }
    func setupTableView(){
        tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "completedCell")
    }
    
    func loadRealmData(){
        let objects = realm.objects(FFTrainingPlanRealmModel.self).filter("trainingCompleteStatus == %@", true)
        let data = Array(objects)
        completedPlans = data
    }
    
    func startTimer(_ index: Int,_ tableView: UITableView){
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
            self?.deleteSelectedCell(index, tableView)
        })
    }
    
    func deleteSelectedCell(_ index: Int,_ tableView: UITableView) {
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .top)
        try! realm.write({
            self.completedPlans[index].trainingCompleteStatus = false
        })
        self.completedPlans.remove(at: index)
        self.resetTimer()
    }
    
    func resetTimer(){
        timer?.invalidate()
        timer = nil
    }
    
}

extension FFPlanCompletedTrainingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "completedCell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "completedCell")
        let date = completedPlans[indexPath.row].trainingDate
        cell.textLabel?.text = completedPlans[indexPath.row].trainingName
        cell.detailTextLabel?.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        return cell
    }
}

extension FFPlanCompletedTrainingViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data = completedPlans[indexPath.row]
        let deleteInstance = UIContextualAction(style: .destructive, title: "") { [unowned self] _, _, _ in
            tableView.beginUpdates()
            deleteModel(data)
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
        }
        deleteInstance.backgroundColor = UIColor.systemRed
        deleteInstance.image = UIImage(systemName: "trash.fill")
        deleteInstance.image?.withTintColor(.systemBackground)
        let action = UISwipeActionsConfiguration(actions: [deleteInstance])
        return action
    }
    
    func deleteModel(_ model: FFTrainingPlanRealmModel){
        try! realm.write({
            realm.delete(model)
        })
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data = completedPlans[indexPath.row]
        let completeInstance = UIContextualAction(style: .normal, title: "") { [unowned self] _, _, _ in
            tableView.beginUpdates()
            try! self.realm.write({
                self.completedPlans[indexPath.row].trainingCompleteStatus = false
            })
            completedPlans.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
        }
        completeInstance.backgroundColor = FFResources.Colors.activeColor
        completeInstance.image = UIImage(systemName: "checkmark.square")
        completeInstance.image?.withTintColor(.systemBackground)
        let action = UISwipeActionsConfiguration(actions: [completeInstance])
        return action
    }
}

extension FFPlanCompletedTrainingViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
