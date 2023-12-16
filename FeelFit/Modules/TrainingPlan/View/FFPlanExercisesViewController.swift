//
//  FFPlanExercisesViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 04.12.2023.
//

import UIKit
import RealmSwift

protocol PlanExerciseDelegate: AnyObject {
    func deliveryData(exercises: [Exercise])
}

class FFPlanExercisesViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFPlanExercisesViewModel!
    weak var delegate: PlanExerciseDelegate?
    
    private let key: String
    private let typeRequest: String
    private var loadData: [Exercise]?
    
    private var selectedExercise: [Exercise] = [Exercise]()
    private var status: Bool = false
    
    
    private var numberOfSelectedCells: Int {
        return tableView.indexPathsForSelectedRows?.count ?? 0
    }
    
    init(key: String, typeRequest: String,title: String) {
        self.key = key
        self.typeRequest = typeRequest
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var tableView: UITableView!
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.tintColor = FFResources.Colors.activeColor
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupConstraints()
    }
    
    @objc private func didTapSave(){
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count > 4 {
                let targetVC = viewControllers[viewControllers.count-3]
                delegate?.deliveryData(exercises: selectedExercise)
                self.navigationController?.popToViewController(targetVC, animated: true)
            }
        }

    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupNavigationController() { }
    
    func setupViewModel() {
        viewModel = FFPlanExercisesViewModel(viewController: self)
        viewModel.delegate = self
        viewModel.loadData(key: key, filter: typeRequest)
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(FFExercisesMuscleTableViewCell.self, forCellReuseIdentifier: FFExercisesMuscleTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
    }
    
    func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(spinner)
        spinner.center = view.center
    }
    
    func updateNavigation(){
        let button = addNavigationBarButton(title: "Done", imageName: "", action: #selector(didTapSave), menu: nil)
        if numberOfSelectedCells > 0 {
            navigationItem.setRightBarButton(button, animated: true)
        } else {
            navigationItem.setRightBarButton(nil, animated: true)
        }
    }
    
    func checkAvailableData(exercise: Exercise) {
        let realm = try! Realm()
        let model = realm.objects(FFFavouriteExerciseRealmModel.self).filter("exerciseID == %@", exercise.exerciseID)
        let boolean = !model.isEmpty ? true : false
        status = boolean
    }
    
    func favouriteExerciseAction(exercise: Exercise){
        if status {
            FFFavouriteExerciseStoreManager.shared.deleteExerciseWith(model: exercise)
            status.toggle()
        } else {
            try! FFFavouriteExerciseStoreManager.shared.saveExercise(exercise: exercise)
            status.toggle()
        }
    }
}

extension FFPlanExercisesViewController: FFExerciseProtocol {
    func viewWillLoadData() {
        spinner.startAnimating()
    }
    
    func viewDidLoadData(result: Result<[Exercise], Error>) {
        switch result {
        case .success(let success):
            loadData = success
        case .failure(let failure):
            viewAlertController(text: failure.localizedDescription, startDuration: 0.5, timer: 3, controllerView: view)
            DispatchQueue.main.asyncAfter(deadline: .now()+1){ [unowned self] in
                navigationController?.popViewController(animated: true)
            }
        }
        DispatchQueue.main.async { [unowned self] in
            tableView.reloadData()
            spinner.stopAnimating()
        }
    }
}

extension FFPlanExercisesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFExercisesMuscleTableViewCell.identifier, for: indexPath) as! FFExercisesMuscleTableViewCell
        let data = loadData?[indexPath.row]
        cell.accessoryType = .none
        cell.tintColor = FFResources.Colors.activeColor
        cell.configureView(keyName: key, exercise: data!, indexPath: indexPath, isSearching: false)
        return cell
    }
}

extension FFPlanExercisesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let data = loadData?[indexPath.row] else { return nil}
        return viewModel.tableView(tableView, contextMenuConfigurationForRowAt: indexPath, point: point, loadData: loadData, boolean: status) {
            self.favouriteExerciseAction(exercise: data)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedExercise = viewModel.tableView(tableView, didSelectRowAt: indexPath, loadedData: loadData, selectedExercise: selectedExercise) {
            updateNavigation()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedExercise = viewModel.tableView(tableView, didDeselectRowAt: indexPath, loadData, exercises: selectedExercise,action: {
            updateNavigation()
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
}
