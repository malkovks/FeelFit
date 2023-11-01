//
//  FFExerciseDescriptionViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 01.11.2023.
//

import UIKit
import YouTubeiOSPlayerHelper

class FFExerciseDescriptionViewController: UIViewController, SetupViewController {
    
    let exercise: Exercises
    
    init(exercise: Exercises) {
        self.exercise = exercise
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameExerciseLabel: UILabel = {
        let label = UILabel()
        label.font = .headerFont(size: 24)
        label.textColor = FFResources.Colors.textColor
        label.numberOfLines = 1
        label.textAlignment = .left
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        return label
    }()
    
    let typeExerciseLabel: UILabel = {
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
       let textView = UITextView()
        textView.layer.cornerRadius = 12
        textView.textColor = FFResources.Colors.textColor
        textView.isEditable = false
        textView.allowsEditingTextAttributes = true
        textView.backgroundColor = .systemRed
        return textView
    }()
    
    var exerciseDesctiptionPlayerView: YTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigationController()
        setupConstraints()
        configureView()
    }
    
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        exerciseDesctiptionPlayerView = YTPlayerView()
        exerciseDesctiptionPlayerView.delegate = self
        
        exerciseDesctiptionPlayerView.load(withVideoId: "z0eulElSJK0")
    }
    
    func setupNavigationController() {
        title = "Description"
    }
    
    func configureView(){
        nameExerciseLabel.text = "Name: " + exercise.name
        typeExerciseLabel.text = "Type: " + exercise.type
        muscleExerciseLabel.text = "Muscle group: " + exercise.muscle
        difficultExerciseLabel.text = "Difficult: " + exercise.difficulty
        equipmentExerciseLabel.text = "Equipment: " + exercise.equipment
        descriptionTextView.text = exercise.instructions
    }

}

extension FFExerciseDescriptionViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
//        exerciseDesctiptionPlayerView.playVideo()
    }

}

extension FFExerciseDescriptionViewController {
    private func setupConstraints(){
        let stackView = UIStackView(arrangedSubviews: [nameExerciseLabel, typeExerciseLabel, muscleExerciseLabel, equipmentExerciseLabel, difficultExerciseLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.alignment = .leading
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().dividedBy(4)
        }
        
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().dividedBy(4)
        }
        
        view.addSubview(exerciseDesctiptionPlayerView)
        exerciseDesctiptionPlayerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
