//
//  FFSearchPlanResultViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 09.01.2024.
//

import UIKit

class FFSearchPlanResultViewController: UIViewController,SetupViewController {
    
    var tableView: UITableView!
    var filteredData: [FFTrainingPlanRealmModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
        setupViewModel()
        setupNavigationController()
        
        setupConstraints()
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        
    }
}

extension FFSearchPlanResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        let data  = filteredData[indexPath.row]
        cell.textLabel?.text = DateFormatter.localizedString(from: data.trainingDate, dateStyle: .short, timeStyle: .short)
        return cell
    }
}

extension FFSearchPlanResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FFSearchPlanResultViewController {
    func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
