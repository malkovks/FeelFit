//
//  FFAddExerciseViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 29.11.2023.
//

import UIKit
import Kingfisher
import RealmSwift

/// Class for adding exercises to created base program plan
class FFAddExerciseViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFAddExerciseViewModel!
    
    
    private var trainProgram: CreateTrainProgram?
    var model = [FFExerciseModelRealm]()
    private var trainPlanModel: FFTrainingPlanRealmModel?
    private let isViewEditing: Bool
    private var editedTrainPlanModel: FFTrainingPlanRealmModel?
    
    init(trainProgram: CreateTrainProgram?,exercises: List<FFExerciseModelRealm>? = nil,_ isViewEditing: Bool = false,trainPlanModel: FFTrainingPlanRealmModel? = nil) {
        self.trainProgram = trainProgram
        self.isViewEditing = isViewEditing
        guard let exercises = exercises,
              let models = trainPlanModel else {
            super.init(nibName: nil, bundle: nil)
            return
        }
        for exercise in exercises {
            model.append(exercise)
        }
        self.trainPlanModel = models
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
        if model.count > 0  {
            viewModel.didTapConfirmSaving(plan: trainProgram, model: model)
        } else {
            alertControllerActionConfirm(title: "Warning", message: "You exercise list is empty. Are you sure you want to save plan without including them?", confirmActionTitle: "Continue",secondTitleAction: "", style: .alert) {
                self.viewModel.didTapConfirmSaving(plan: self.trainProgram, model: self.model)
            } secondAction: {
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc private func didTapEditPlan(){
        viewModel.didTapEditPlan(trainProgram, model, trainPlanModel)
    }
    
    //MARK: - Setup View methods
    func setupViewModel() {
        viewModel = FFAddExerciseViewModel(viewController: self)
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero,style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.estimatedSectionFooterHeight = 40
        tableView.register(FFAddExerciseTableViewCell.self, forCellReuseIdentifier: FFAddExerciseTableViewCell.identifier)
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupNavigationController() {
        title = "Exercises"
        navigationItem.largeTitleDisplayMode = .never
        if isViewEditing {
            navigationItem.setLeftBarButton(addNavigationBarButton(title: "Edit", imageName: "", action: #selector(didTapEditPlan), menu: nil), animated: true)
        } else {
            navigationItem.setLeftBarButton(addNavigationBarButton(title: "Save", imageName: "", action: #selector(didTapSave), menu: nil), animated: true)
        }
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
        let vc = FFExerciseDescriptionViewController(exercise: exercise, isElementsHidden: true)
        let configuration = UIContextMenuConfiguration {
            return vc
        } actionProvider: { _ in
            let openView = UIAction(title: "Open") { _ in
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let deleteExercise = UIAction(title: "Delete", image: UIImage(systemName: "trash"),attributes: .destructive) { [unowned self] _ in
                tableView.beginUpdates()
                model.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .top)
                tableView.endUpdates()
            }
            return UIMenu(children: [openView,deleteExercise])
        }
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let value = model[indexPath.row]
        setupExerciseSecondaryParameters() { data in
            value.exerciseWeight = data[0]
            value.exerciseApproach = data[1]
            value.exerciseRepeat = data[2]
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        view.setNeedsDisplay()
        let deleteInstance = UIContextualAction(style: .destructive, title: "") { [unowned self] _, _, _ in
            tableView.beginUpdates()
            model.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
        }
        deleteInstance.backgroundColor = UIColor.systemRed
        deleteInstance.image = UIImage(systemName: "trash.fill")
        deleteInstance.image?.withTintColor(FFResources.Colors.backgroundColor)
        let action = UISwipeActionsConfiguration(actions: [deleteInstance])
        return action
    }
    
    //Drag func
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = model.remove(at: sourceIndexPath.row)
        model.insert(mover, at: sourceIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        viewModel.tableView(tableView, heightForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        viewModel.tableView(tableView, viewForFooterInSection: section, isViewEditing, editAction: #selector(didTapEditPlan), saveAction: #selector(didTapSave))
    }
}

extension FFAddExerciseViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        viewModel.tableView(tableView, itemsForBeginning: session, at: indexPath, model)
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
