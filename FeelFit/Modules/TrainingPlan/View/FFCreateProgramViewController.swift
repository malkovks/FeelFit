//
//  FFCreateProgramViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 09.11.2023.
//

import UIKit

struct TrainingSetup {
    let basic: BasicSettings
    let warmUp: WarmUpSettings
    let mainTrainPart: MainTrainingPart
    let hitch: HitchSettings
}

struct BasicSettings {
    
}

struct WarmUpSettings {
    
}

struct MainTrainingPart {
    
}

struct HitchSettings {
    
}

class FFCreateProgramViewController: UIViewController, SetupViewController {
    
    var viewModel: FFCreateProgramViewModel!
    
    var tableViewTextSetup = [
        "Basic Settings" :["Duration","Location","Type Training"],//тип тренировки - силовые, кардио, круговые, растяжка
        "Warm Up": ["Duration","Type of Warming Up"],//Тип разминки - бег, скакалка, упражнения на разные мышцы, упражнения на гибкость
        "Main Part Of Workout" : ["Approaches","Repeats","Exercise"],//здесь надо добавить в хедер кнопку добавления еще одной секции в случае если пользователь захочет добавить упражнения
        "Hitch" : ["Duration","Cool Down Type"]
    ]
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        setupViewModel()
        setupNavigationController()
        setupConstraints()
    }
    
    func setupViewModel(){
        viewModel = FFCreateProgramViewModel(viewController: self)
    }
    
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    func setupNavigationController() {
        title = "Create new plan"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = .clear
        tableView.sectionIndexColor = .orange
        tableView.layer.cornerRadius = 12
    }
}

extension FFCreateProgramViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewTextSetup.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let sectionIndex = tableViewTextSetup.index(tableViewTextSetup.startIndex, offsetBy: section)
//        let key = tableViewTextSetup.keys[sectionIndex]
//        return tableViewTextSetup[key]?.count ?? 0
        let key = Array(tableViewTextSetup.keys.sorted())[section]
        let values = tableViewTextSetup[key]?.sorted(by: { $0 < $1 }) ?? []
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
//        let index = tableViewTextSetup.index(tableViewTextSetup.startIndex, offsetBy: indexPath.section)
//        let key = tableViewTextSetup.keys[index]
//        let value = tableViewTextSetup[key]
        let key = Array(tableViewTextSetup.keys.sorted())[indexPath.section]
        let values = tableViewTextSetup[key]?.sorted(by: { $0 < $1 }) ?? []
    
        cell.layer.cornerRadius = 12
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.backgroundColor = .systemGreen
//        cell.textLabel?.text = value?[indexPath.row]
        cell.textLabel?.text = values[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let sectionIndex = tableViewTextSetup.index(tableViewTextSetup.startIndex, offsetBy: section)
//        let value = tableViewTextSetup.keys[sectionIndex]
        let sortedKeys = tableViewTextSetup.keys.sorted(by: { $0 < $1 })
        return sortedKeys[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "footer of \(section + 1) number"
    }
}

extension FFCreateProgramViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension FFCreateProgramViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(3)
        }
    }
}
