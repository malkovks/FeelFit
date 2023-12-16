//
//  FFMuscleGroupSelectionViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 01.12.2023.
//

import UIKit

///Class for selecting one of 15 type of muscles and segue to choose exercise for this muscle group
class FFMuscleGroupSelectionViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFMuscleGroupSelectionViewModel!
    private var dataSource: FFMuscleGroupTableViewDataSource!
    
    weak var delegate: PlanExerciseDelegate?
    var exerciseData: [Exercise] = [Exercise]()
    
    private var tableView: UITableView!
    private let segment: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Muscles","Body Part"])
        control.selectedSegmentIndex = 0
        control.tintColor = FFResources.Colors.activeColor
        control.selectedSegmentTintColor = FFResources.Colors.activeColor
        control.backgroundColor = .systemBackground
        control.layer.cornerRadius = 8
        control.layer.borderColor = FFResources.Colors.textColor.cgColor
        control.layer.borderWidth = 0.5
        control.layer.masksToBounds = true
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
        "quads" : "Quadriceps",
        "serratus_anterior" : "Serratus Anterior",
        "spine" : "Spine",
        "traps" : "Traps",
        "triceps" : "Triceps",
        "upper_back" : "Upper Back"
    ]
    
    var bodyPartDictionary = [
        "back" : "Back",
        "cardio" : "Cardio",
        "chest" : "Chest",
        "lower_arms" : "Lower arms",
        "lower_legs" : "Lower legs",
        "neck" : "Neck",
        "shoulders" : "Shoulders"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setupTableView()
        setupNavigationController()
        setupConstraints()
    }
    
    @objc private func didTapSegmentalControl(sender: UISegmentedControl){
        let value = viewModel.settingSegmentController(segment: sender, firstData: muscleDictionary, secondData: bodyPartDictionary)
        setupTableViewDataSource(value)
    }
    //MARK: - Setup view controller
    func setupTableViewDataSource(_ data: [String: String]){
        dataSource = FFMuscleGroupTableViewDataSource(data: data, viewController: self)
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
        segment.addTarget(self, action: #selector(didTapSegmentalControl), for: .valueChanged)
    }
    
    func setupTableView(){
        
        dataSource = FFMuscleGroupTableViewDataSource(data: muscleDictionary, viewController: self)
        tableView = UITableView(frame: .zero,style: .grouped)
        
        tableView.tableFooterView = nil
        tableView.sectionFooterHeight = 0
        
        tableView.tableHeaderView = segment
        tableView.register(FFMuscleGroupTableViewCell.self, forCellReuseIdentifier: FFMuscleGroupTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = dataSource
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5){ [unowned self] in
            tableView.reloadData()
        }
    }
    
    func setupNavigationController() {
        title = "Muscles"
    }
    
    func setupViewModel() {
        viewModel = FFMuscleGroupSelectionViewModel(self)
    }
}
//MARK: - UITableViewDelegate
extension FFMuscleGroupSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.indexReturnResult(indexPath: indexPath, firstData: muscleDictionary, secondData: bodyPartDictionary, segment: segment)
        let key = data.0
        let request = data.1
        let vc = FFPlanExercisesViewController(key: key, typeRequest: request, title: key.capitalized)
        vc.delegate = self
        viewModel.tableView(tableView, didSelectRowAt: indexPath,key: key, request: request,controller: vc)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
}

extension FFMuscleGroupSelectionViewController: PlanExerciseDelegate {
    func deliveryData(exercises: [Exercise]) {
        exerciseData.append(contentsOf: exercises)
        print(exercises.count)
        delegate?.deliveryData(exercises: exercises)
    }
    
}
//MARK: - Size extension
extension FFMuscleGroupSelectionViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

