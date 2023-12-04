//
//  FFPlanExercisesViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 04.12.2023.
//

import UIKit

class FFPlanExercisesViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFPlanExercisesViewModel!
    
    private let key: String
    private let typeRequest: String
    private var loadData: [Exercise]?
    
    init(key: String, typeRequest: String) {
        
        self.key = key
        self.typeRequest = typeRequest
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData(key: key, filter: typeRequest)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupConstraints()
        tableView.reloadData()
    }
    
    func loadData(key: String,filter type: String){
        FFGetExercisesDataBase.shared.getMuscleDatabase(muscle: key,filter: type) { result in
            switch result {
            case .success(let success):
                self.loadData = success
            case .failure(let failure):
                print(failure)
                self.loadData = [Exercise]()
            }
        }
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupNavigationController() {
        title = "Exercises"
    }
    
    func setupViewModel() {
        viewModel = FFPlanExercisesViewModel(viewController: self)
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(FFExercisesMuscleTableViewCell.self, forCellReuseIdentifier: FFExercisesMuscleTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        cell.configureView(keyName: key, exercise: data!, indexPath: indexPath)
        return cell
    }
}

extension FFPlanExercisesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
}
