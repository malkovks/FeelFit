//
//  FFAddExerciseViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 29.11.2023.
//

import UIKit

class FFAddExerciseViewController: UIViewController, SetupViewController {
    
    private let trainProgram: CreateTrainProgram?
    private let exercises = [Exercise]()
    
    init(trainProgram: CreateTrainProgram?) {
        self.trainProgram = trainProgram
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupTableView()
        if exercises.isEmpty {
            contentUnavailableConfiguration =  configureUnavailableContent { [unowned self] in
                setupTableView()
                didTapAddExercise()
            }
        } else {
            setupConstraints()
        }
    }
    
    @objc private func didTapAddExercise(){
        let vc = FFMusclesGroupViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureUnavailableContent(action: @escaping () -> ()) -> UIContentUnavailableConfiguration {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No exercises"
        config.image = UIImage(systemName: "figure.strengthtraining.traditional")
        config.button = .plain()
        config.button.image = UIImage(systemName: "plus")
        config.button.baseForegroundColor = FFResources.Colors.activeColor
        config.button.title = "Add exercise"
        config.button.imagePlacement = .leading
        config.button.imagePadding = 2
        config.buttonProperties.primaryAction = UIAction(handler: { _ in
            action()
        })
        return config
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero,style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "exerciseCell")
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
    }
    
    func setupNavigationController() {
        title = "Exercises"
        navigationItem.largeTitleDisplayMode = .never
    }
    
}

extension FFAddExerciseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        cell.textLabel?.text = "Text"
        cell.imageView?.image = UIImage(systemName: "figure.highintensity.intervaltraining")
        return cell
    }
}

extension FFAddExerciseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension FFAddExerciseViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
