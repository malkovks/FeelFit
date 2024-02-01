//
//  FFExerciseDescriptionViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 01.11.2023.
//

import UIKit
import SafariServices
import Alamofire
import RealmSwift
import Kingfisher

class FFExerciseDescriptionViewController: UIViewController, SetupViewController {
    
    private var saveStatus: Bool = false
    
    var viewModel: FFExerciseDescriptionViewModel!
    
    let exercise: Exercise
    let isElementsHidden: Bool
    
    init(exercise: Exercise,isElementsHidden: Bool) {
        self.exercise = exercise
        self.isElementsHidden = isElementsHidden
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameExerciseLabel: UILabel = {
        let label = UILabel()
        label.font = .headerFont(size: 24)
        label.textColor = FFResources.Colors.textColor
        label.numberOfLines = 3
        label.textAlignment = .left
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        return label
    }()
    
    let secondaryMusclesLabel: UILabel = {
        let label = UILabel()
        label.font = .detailLabelFont()
        label.textColor = FFResources.Colors.textColor
        label.numberOfLines = 1
        label.textAlignment = .left
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        return label
    }()
    
    let muscleExerciseLabel: UILabel = {
        let label = UILabel()
        label.textColor = FFResources.Colors.detailTextColor
        label.numberOfLines = 1
        label.textAlignment = .left
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        return label
    }()
    
    let equipmentExerciseLabel: UILabel = {
        let label = UILabel()
        label.font = .detailLabelFont(size: 14, weight: .regular, width: .standard)
        label.textColor = FFResources.Colors.detailTextColor
        label.numberOfLines = 1
        label.textAlignment = .left
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        return label
    }()
    
    let difficultExerciseLabel: UILabel = {
        let label = UILabel()
        label.font = .textLabelFont(size: 18, weight: .heavy, width: .condensed)
        label.textColor = FFResources.Colors.textColor
        label.numberOfLines = 1
        label.textAlignment = .left
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.layer.cornerRadius = 12
        textView.textColor = FFResources.Colors.textColor
        textView.isEditable = false
        textView.allowsEditingTextAttributes = true
        textView.backgroundColor = .clear
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return textView
    }()
    
    var exerciseImageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.backgroundColor = .clear
        return image
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = FFResources.Colors.textColor
        return spinner
    }()
    
    var labelStackView = UIStackView()
    
    let youtubeSegueButton: UIButton = {
       let button = UIButton()
        button.configuration = .tinted()
        button.configuration?.title = "Watch Video Instructions"
        button.configuration?.image = UIImage(systemName: "play.rectangle.fill")
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .leading
        button.configuration?.baseBackgroundColor = FFResources.Colors.activeColor
        button.configuration?.baseForegroundColor = FFResources.Colors.activeColor
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupView()
        setupViewModel()
        setupNavigationController()
        configureView()
        setupConstraints()
        checkSavedStatus()
        setupNavigationController()
    }
    //MARK: - Target methods
    @objc private func didTapOpenSafari(){
        viewModel.openSafari(exercise: exercise)
    }
    
    @objc private func didTapChangeSaveStatus(){
        saveStatus.toggle()
        if saveStatus {
            try! FFFavouriteExerciseStoreManager.shared.saveExercise(exercise: exercise)
        } else {
            FFFavouriteExerciseStoreManager.shared.deleteExerciseWith(model: exercise)
        }
        let image = saveStatus ? "heart.fill" : "heart"
        let text = saveStatus ? "Added to Favourite" : "Removed from Favourite"
        navigationItem.setRightBarButton(addNavigationBarButton(title: "", imageName: image, action: #selector(didTapChangeSaveStatus), menu: nil), animated: true)
        viewAlertController(text: text, startDuration: 0.5, timer: 1.5, controllerView: self.view)
    }
    
    //MARK: - Setup View
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        youtubeSegueButton.addTarget(self, action: #selector(didTapOpenSafari), for: .touchUpInside)
        exerciseImageView.addInteraction(UIContextMenuInteraction(delegate: self))
        exerciseImageView.isUserInteractionEnabled = true
    }
    
    func setupViewModel(){
        viewModel = FFExerciseDescriptionViewModel(viewController: self)
        viewModel.loadingImageView(exercise: exercise) { [unowned self] imageView in
            DispatchQueue.main.async {
                self.exerciseImageView.image = imageView.image
            }
            
        }
    }
    
    func setupNavigationController() {
        title = "Description"
        let image = saveStatus ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "", imageName: image, action: #selector(didTapChangeSaveStatus), menu: nil)
    }
    
    func setupStackView(){
        labelStackView = UIStackView(arrangedSubviews: [nameExerciseLabel, muscleExerciseLabel, secondaryMusclesLabel, equipmentExerciseLabel, difficultExerciseLabel])
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillProportionally
        labelStackView.spacing = 2
        labelStackView.alignment = .fill
        labelStackView.backgroundColor = .clear
    }
    
    func configureView(){
        nameExerciseLabel.text = "Name: " + exercise.exerciseName.formatArrayText()
        secondaryMusclesLabel.text = "Secondary Muscles: " + exercise.secondaryMuscles.joined(separator: ", ").formatArrayText()
        muscleExerciseLabel.text = "Muscle group: " + exercise.muscle.formatArrayText()
        difficultExerciseLabel.text = "Body Part: " + exercise.bodyPart.formatArrayText()
        equipmentExerciseLabel.text = "Equipment: " + exercise.equipment.formatArrayText()
        descriptionTextView.text = exercise.instructions.joined(separator: " ")
    }
    
    func checkSavedStatus(){
        let realm = try! Realm()
        let models = realm.objects(FFFavouriteExerciseRealmModel.self).filter("exerciseID == %@",exercise.exerciseID)
        saveStatus = !models.isEmpty ? true : false
    }
}

extension FFExerciseDescriptionViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        viewModel.contextMenuInteraction(interaction, configurationForMenuAtLocation: location, exercise)
    }
    
    
}

extension FFExerciseDescriptionViewController {
    
    private func setupConstraints(){
        view.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(5)
            make.height.equalToSuperview().dividedBy(4)
        }
        
        let sizeThatFits = descriptionTextView.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat(MAXFLOAT)))
        
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(sizeThatFits).multipliedBy(0.4)
        }
        
        view.addSubview(exerciseImageView)
        exerciseImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(view.frame.size.width/1.5)
        }
        
        view.addSubview(youtubeSegueButton)
        youtubeSegueButton.snp.makeConstraints { make in
            make.top.equalTo(exerciseImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalToSuperview().dividedBy(16)
        }
    }
}
