//
//  FFTRainingPlanViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import Kingfisher

struct TrainingPlan {
    let firstName: String
    let secondName: String
    let detailTraining: String
    let plannedDate: Date
    let durationMinutes: Int
    let location: String
    let exercises: [Exercise]
//    let warmUp: WarmUpExercises
}

class FFTRainingPlanViewController: UIViewController,SetupViewController {
    
    var trainingPlans = Array<TrainingPlan>()
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMockTest()
        setupView()
        setupCollectionView()
        setupNavigationController()
        setupConstraints()
    }
    
    @objc private func didTapCreateProgram(){
        let vc = FFCreateProgramViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupView() {
        
        view.backgroundColor = .systemBackground
        if trainingPlans.isEmpty {
            contentUnavailableConfiguration = configurationView()
        }
    }
    
    func setupMockTest(){
        trainingPlans.append(TrainingPlan(firstName: "Run", secondName: "Interval", detailTraining: "Running with bycicle by pulse ", plannedDate: Date(), durationMinutes: 60, location: "Outside", exercises: [Exercise(bodyPart: "Legs", equipment: "shoes", imageLink: "someLink", exerciseID: "01", exerciseName: "100x10", muscle: "quads,calves", secondaryMuscles: ["some secondary"], instructions: ["Some text"])]))
        trainingPlans.append(TrainingPlan(firstName: "Run", secondName: "Interval", detailTraining: "Running with bycicle by pulse ", plannedDate: Date(), durationMinutes: 60, location: "Outside", exercises: [Exercise(bodyPart: "Legs", equipment: "shoes", imageLink: "someLink", exerciseID: "01", exerciseName: "100x10", muscle: "quads,calves", secondaryMuscles: ["some secondary"], instructions: ["Some text"])]))
        trainingPlans.append(TrainingPlan(firstName: "Run", secondName: "Interval", detailTraining: "Running with bycicle by pulse ", plannedDate: Date(), durationMinutes: 60, location: "Outside", exercises: [Exercise(bodyPart: "Legs", equipment: "shoes", imageLink: "someLink", exerciseID: "01", exerciseName: "100x10", muscle: "quads,calves", secondaryMuscles: ["some secondary"], instructions: ["Some text"])]))
        trainingPlans.append(TrainingPlan(firstName: "Run", secondName: "Interval", detailTraining: "Running with bycicle by pulse ", plannedDate: Date(), durationMinutes: 60, location: "Outside", exercises: [Exercise(bodyPart: "Legs", equipment: "shoes", imageLink: "someLink", exerciseID: "01", exerciseName: "100x10", muscle: "quads,calves", secondaryMuscles: ["some secondary"], instructions: ["Some text"])]))
        trainingPlans.append(TrainingPlan(firstName: "Run", secondName: "Interval", detailTraining: "Running with bycicle by pulse ", plannedDate: Date(), durationMinutes: 60, location: "Outside", exercises: [Exercise(bodyPart: "Legs", equipment: "shoes", imageLink: "someLink", exerciseID: "01", exerciseName: "100x10", muscle: "quads,calves", secondaryMuscles: ["some secondary"], instructions: ["Some text"])]))
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FFTrainingPlanCollectionViewCell.self, forCellWithReuseIdentifier: FFTrainingPlanCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    func configurationView() -> UIContentUnavailableConfiguration{
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No planned trainings"
        config.secondaryText = "Add new training plan to list"
        config.image = UIImage(systemName: "rectangle")
        config.button = .tinted()
        config.button.image = UIImage(systemName: "plus")
        config.button.title = "Add new training plan"
        config.button.imagePlacement = .top
        config.button.imagePadding = 2
        config.button.baseBackgroundColor = FFResources.Colors.activeColor
        config.button.baseForegroundColor = FFResources.Colors.activeColor
        config.buttonProperties.primaryAction = UIAction(handler: { _ in
            self.didTapCreateProgram()
        })
        return config
    }
    
    func setupNavigationController() {
        title = "Train Plan"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: nil, imageName: "rectangle.badge.plus", action: #selector(didTapCreateProgram), menu: nil)
    }
}

extension FFTRainingPlanViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trainingPlans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFTrainingPlanCollectionViewCell.identifier, for: indexPath) as! FFTrainingPlanCollectionViewCell
        let data = trainingPlans[indexPath.row]
        cell.configureLabels(model: data)
        return cell
    }
}

extension FFTRainingPlanViewController: UICollectionViewDelegate {
    
}

extension FFTRainingPlanViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width-10
        let height = CGFloat(view.frame.size.height/5)
        return CGSize(width: width, height: height)
    }
}

extension FFTRainingPlanViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let share = UIAction(title: "Share") { _ in
                print("Share image")
            }
            return UIMenu(children: [share])
        }
    }
}

extension FFTRainingPlanViewController {
    private func setupConstraints(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
}

#Preview  {
    FFTRainingPlanViewController()
}
