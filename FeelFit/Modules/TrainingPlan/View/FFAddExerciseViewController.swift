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
    var exerciseSetup: [String]
}


/// Class for adding exercises to created base program plan
class FFAddExerciseViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFAddExerciseViewModel!
    
    
    private let trainProgram: CreateTrainProgram?
    private var model = [FFExerciseModelRealm]()
    
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
        if model.isEmpty {
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
        viewModel.didTapConfirmSaving(plan: trainProgram, model: model)
    }
    
    //MARK: - Setup View methods
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
}

extension FFAddExerciseViewController: PlanExerciseDelegate {
    func deliveryData(exercises: [Exercise]) {
        let values = viewModel.convertExerciseToRealm(exercises: exercises)
        model.append(contentsOf: values)
        DispatchQueue.main.async { [unowned self] in
            tableView.reloadData()
            setupNonEmptyValue()
        }
    }
}

extension FFAddExerciseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFAddExerciseTableViewCell.identifier, for: indexPath) as! FFAddExerciseTableViewCell
        cell.configureCell(indexPath: indexPath, data: model)
        return cell
    }
}

extension FFAddExerciseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let exercise = viewModel.convertRealmModelToExercise(model)[indexPath.row]
        let vc = FFExerciseDescriptionViewController(exercise: exercise)
        let configuration = UIContextMenuConfiguration {
            return vc
        } actionProvider: { _ in
            let openView = UIAction(title: "Open") { _ in
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return UIMenu(children: [openView])
        }
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let value = model[indexPath.row]
        alertData(view: self.view) { data in
            value.exerciseWeight = data[0]
            value.exerciseApproach = data[1]
            value.exerciseRepeat = data[2]
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
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
    func alertData(view: UIView,handler: @escaping ([String])-> ()?){
        let alertController = UIAlertController(title: "Fill the fields", message: nil, preferredStyle: .alert)
        
        //Label Setup
        let weightLabel = UILabel(frame: .zero)
        weightLabel.text = "Weight :"
        weightLabel.font = UIFont.textLabelFont()
        weightLabel.textColor = FFResources.Colors.textColor
        weightLabel.textAlignment = .justified
        
        let setsLabel = UILabel(frame: .zero)
        setsLabel.text = "Sets :"
        setsLabel.font = UIFont.textLabelFont()
        setsLabel.textColor = FFResources.Colors.textColor
        setsLabel.textAlignment = .justified
        
        let repeatLabel = UILabel(frame: .zero)
        repeatLabel.text = "Repeats :"
        repeatLabel.font = UIFont.textLabelFont()
        repeatLabel.textColor = FFResources.Colors.textColor
        repeatLabel.textAlignment = .justified
        
        let labelStackView = UIStackView(arrangedSubviews: [weightLabel,setsLabel,repeatLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 10
        labelStackView.alignment = .fill
        labelStackView.distribution = .fillProportionally

        //TextField Setup
        let weightTextField = UITextField(frame: .zero)
        weightTextField.borderStyle = .roundedRect
        weightTextField.placeholder = "Weight value"
        weightTextField.keyboardType = .numberPad
        weightTextField.font = UIFont.textLabelFont()
        weightTextField.textColor = FFResources.Colors.textColor
        weightTextField.textAlignment = .center
        
        
        let setsTextField = UITextField(frame: .zero)
        setsTextField.borderStyle = .roundedRect
        setsTextField.placeholder = "Sets value"
        setsTextField.keyboardType = .numberPad
        setsTextField.font = UIFont.textLabelFont()
        setsTextField.textColor = FFResources.Colors.textColor
        setsTextField.textAlignment = .center

        let repeatTextField = UITextField(frame: .zero)
        repeatTextField.borderStyle = .roundedRect
        repeatTextField.placeholder = "Sets value"
        repeatTextField.keyboardType = .numberPad
        repeatTextField.font = UIFont.textLabelFont()
        repeatTextField.textColor = FFResources.Colors.textColor
        repeatTextField.textAlignment = .center

        let textFieldStackView = UIStackView(arrangedSubviews: [weightTextField, setsTextField, repeatTextField])
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = 10
        textFieldStackView.distribution = .fillProportionally
        
        //Stack view from two stack views
        let stackView = UIStackView(arrangedSubviews: [labelStackView,textFieldStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.alignment = .fill
        
        alertController.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(120)
        }
        
        alertController.view.snp.makeConstraints { make in
            make.height.equalTo(220)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let text = weightTextField.text,
                    let secondText = setsTextField.text,
                    let thirdText = repeatTextField.text else {
                return
            }
            let value: [String] = [text, secondText, thirdText]
            handler(value)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}
