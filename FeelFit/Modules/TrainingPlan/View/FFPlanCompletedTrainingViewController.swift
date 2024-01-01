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
    
    private var completedPlans: Results<FFTrainingPlanRealmModel>!
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setupNavigationController()
        setupTableView()
        setupConstraints()
        loadRealmData()
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
        
        //Если таблица пустая, добавить contentUnavailableConfiguration
    }
    
    func setupNavigationController() {
        title = "Completed"
    }
    
    func setupViewModel() {
        
    }
    func setupTableView(){
        tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "completedCell")
    }
    
    func loadRealmData(){
        let objects = realm.objects(FFTrainingPlanRealmModel.self).filter("trainingCompleteStatus == %@", true)
        completedPlans = objects
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

extension FFPlanCompletedTrainingViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
