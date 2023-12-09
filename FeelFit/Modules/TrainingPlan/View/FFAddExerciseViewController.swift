//
//  FFAddExerciseViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 29.11.2023.
//

import UIKit
import Kingfisher

struct TrainingPlanModel {
    var firstPartTrain: CreateTrainProgram
    var exercises: [Exercise]
}


/// Class for adding exercises to created base program plan
class FFAddExerciseViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFAddExerciseViewModel!
    
    private let trainProgram: CreateTrainProgram?
    private var exercises = [Exercise]()
    
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
        setupViewModel()
        setupNavigationController()
        setupTableView()
        if exercises.isEmpty {
            contentUnavailableConfiguration =  viewModel.configureView { [unowned self] in
                didTapAddExercise()
            }
        } else {
            setupNonEmptyValue()
        }
    }
    
    //MARK: - Target methods
    @objc private func didTapAddExercise(){
        let vc = FFMuscleGroupSelectionViewController()
        vc.delegate = self
        viewModel.addExercise(vc: vc)
    }
    
    @objc private func didTapSave(){
        alertControllerActionConfirm(title: "Warning", message: "Save created program?", confirmActionTitle: "Save", style: .actionSheet) { [unowned self] in
            saveConfirmedData()
            navigationController?.popToRootViewController(animated: true)
        } secondAction: { [unowned self] in
            print("not saved in realm")
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    //MARK: - Setup View methods
    
    func saveConfirmedData(){
        guard let data = trainProgram else { return }
        FFTrainingPlanStoreManager.shared.savePlan(plan: data, exercises: exercises)
    }
    
    func setupViewModel() {
        viewModel = FFAddExerciseViewModel(viewController: self)
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero,style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FFAddExerciseTableViewCell.self, forCellReuseIdentifier: FFAddExerciseTableViewCell.identifier)
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
    }
    
    func setupNavigationController() {
        title = "Exercises"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setLeftBarButton(addNavigationBarButton(title: "Save", imageName: "", action: #selector(didTapSave), menu: nil), animated: true)
    }
    
    func setupNonEmptyValue(){
        setupConstraints()
        navigationItem.setRightBarButton(addNavigationBarButton(title: "Add", imageName: "plus", action: #selector(didTapAddExercise), menu: nil), animated: true)
    }
    
    func loadImage(_ link: String,handler: @escaping ((Data) -> ())){
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { data ,_,_ in
            if let data = data {
                handler(data)
                DispatchQueue.main.async { [unowned self] in
                    tableView.reloadData()
                }
            }
        }.resume()
    }
}

extension FFAddExerciseViewController: PlanExerciseDelegate {
    func deliveryData(exercises: [Exercise]) {
        self.exercises.append(contentsOf: exercises)
        DispatchQueue.main.async { [unowned self] in
            tableView.reloadData()
            setupNonEmptyValue()
        }
    }
}

extension FFAddExerciseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFAddExerciseTableViewCell.identifier, for: indexPath) as! FFAddExerciseTableViewCell
        cell.configureCell(indexPath: indexPath, data: exercises)
        return cell
    }
}

extension FFAddExerciseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let exercise = exercises[indexPath.row]
        let vc = FFExerciseDescriptionViewController(exercise: exercise)
        dump(exercise)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FFAddExerciseViewController {
    private func setupConstraints(){
        contentUnavailableConfiguration = nil
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension UIViewController {
    func alertControllerActionConfirm(title: String?, message: String?,confirmActionTitle: String,style: UIAlertController.Style,action: @escaping () -> (), secondAction: @escaping () -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let confirmAction = UIAlertAction(title: confirmActionTitle, style: .default) { _ in
            action()
        }
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
            secondAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
