//
//  FFExerciseDescriptionViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 01.11.2023.
//

import UIKit
import SafariServices
import Kingfisher
import Alamofire

class FFExerciseDescriptionViewController: UIViewController, SetupViewController {
    
    let exercise: Exercise
    
    init(exercise: Exercise) {
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
    
    let exerciseImageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.backgroundColor = FFResources.Colors.activeColor
        return image
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = FFResources.Colors.activeColor
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
        setupNavigationController()
        configureView()
        configureGifImageView()
        setupConstraints()
        
    }
    
    @objc private func didTapOpenSafari(){
        let url = "https://www.youtube.com/results?search_query="
        let modifiedRequest = exercise.exerciseName.replacingOccurrences(of: " ", with: "+")
        guard let completeURL = URL(string: url+modifiedRequest) else { return }
        openYoutubeApp(with: completeURL)
    }
    
    func openYoutubeApp(with url: URL){
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        } else {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        youtubeSegueButton.addTarget(self, action: #selector(didTapOpenSafari), for: .touchUpInside)
    }
    
    func setupNavigationController() {
        title = "Description"
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
        var numberCount = 1
        
        nameExerciseLabel.text = "Name: " + exercise.exerciseName.formatArrayText()
        secondaryMusclesLabel.text = "Secondary Muscles: " + exercise.secondaryMuscles.joined(separator: ", ").formatArrayText()
        muscleExerciseLabel.text = "Muscle group: " + exercise.muscle.formatArrayText()
        difficultExerciseLabel.text = "Body Part: " + exercise.bodyPart.formatArrayText()
        equipmentExerciseLabel.text = "Equipment: " + exercise.equipment.formatArrayText()
        descriptionTextView.text = exercise.instructions.joined(separator: " ")
    }
    
    func configureGifImageView(){
        exerciseImageView.addSubview(spinner)
        spinner.center = exerciseImageView.center
        spinner.startAnimating()
        guard let imageURL = URL(string: exercise.imageLink) else { return }
        exerciseImageView.kf.setImage(with: imageURL)
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }

}

extension FFExerciseDescriptionViewController {
    private func setupConstraints(){
    
        let squareForm = view.frame.size.width/1.5
        
        
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
            make.height.width.equalTo(squareForm)
        }
        
        view.addSubview(youtubeSegueButton)
        youtubeSegueButton.snp.makeConstraints { make in
            make.top.equalTo(exerciseImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalToSuperview().dividedBy(16)
        }
    }
}
