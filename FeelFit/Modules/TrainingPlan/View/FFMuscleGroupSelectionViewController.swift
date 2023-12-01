//
//  FFMuscleGroupSelectionViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 01.12.2023.
//

import UIKit

class FFMuscleGroupSelectionViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFMuscleGroupSelectionViewModel!
    
    private var tableView: UITableView!
    private let segment: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Body Part","Muscles"])
        control.selectedSegmentIndex = 0
        control.tintColor = FFResources.Colors.activeColor
        control.backgroundColor = .systemBackground
        return control
    }()
    
    var muscleDictionary = [
        "abs" : "Abdominals",
        "abductors" : "Abductors",
        "adductors" : "Adductors",
        "biceps" : "Biceps",
        "calves" : "Calves",
        "cardiovascular_system" : "Circulatory System",
        "delts" : "Delts",
        "forearms" : "Forearms",
        "glutes" : "Glutes",
        "hamstrings" : "Hamstrings",
        "lats" : "Lats",
        "pectorals" : "Pectorals",
        "neck" : "Neck",
        "oblique" : "Obliques",
        "quads" : "Quadriceps",
        "serratus_anterior" : "Serratus Anterior",
        "spine" : "Spine",
        "traps" : "Traps",
        "triceps" : "Triceps",
        "upper_back" : "Upper Back"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setupTableView()
        setupNavigationController()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero,style: .insetGrouped)
        tableView.tableFooterView = nil
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = segment
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "muscleGroupID")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationController() {
        title = "Muscles"
    }
    
    func setupViewModel() {
        viewModel = FFMuscleGroupSelectionViewModel(self)
    }
}

extension FFMuscleGroupSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "muscleGroupID", for: indexPath)
        let key = Array(muscleDictionary.keys.sorted())[indexPath.row]
        let valueName = muscleDictionary[key]
        cell.imageView?.image = UIImage(named: key)
        cell.imageView?.layer.cornerRadius = 8
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.sizeThatFits(CGSize(width: 50, height: 50))
        cell.textLabel?.text = valueName
        cell.textLabel?.font = UIFont.textLabelFont(size: 24)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        muscleDictionary.keys.count
    }
    
    
}

extension FFMuscleGroupSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
}

extension FFMuscleGroupSelectionViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
