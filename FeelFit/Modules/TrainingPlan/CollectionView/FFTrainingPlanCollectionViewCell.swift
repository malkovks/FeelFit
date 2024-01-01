//
//  FFTrainingPlanCollectionViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 11.11.2023.
//

import UIKit
import RealmSwift

protocol TrainingPlanCompleteStatusProtocol: AnyObject {
    func planStatusWasChanged(_ status: Bool,arrayPlace: Int)
}

class FFTrainingPlanCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrainingPlanCell"
    
    private var isTrainingCompleted: Bool = false
    
    weak var delegate: TrainingPlanCompleteStatusProtocol?
    
    let completeStatusButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .clear
        button.tintColor = FFResources.Colors.activeColor
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.font = .headerFont()
        label.textColor = FFResources.Colors.textColor
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let detailLabel: UILabel = {
       let label = UILabel()
        label.font = .headerFont()
        label.textColor = FFResources.Colors.textColor
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.font = .headerFont()
        label.textColor = FFResources.Colors.textColor
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let muscleGroupLabel: UILabel = {
       let label = UILabel()
        label.font = .headerFont()
        label.textColor = FFResources.Colors.textColor
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapSave(){
        if isTrainingCompleted {
            isTrainingCompleteSetup(isTrainingCompleted)
        } else {
            isTrainingCompleteSetup(isTrainingCompleted)
        }
    }
    
    func isTrainingCompleteSetup(_ status: Bool) {
        let labels = [ nameLabel,detailLabel,dateLabel,muscleGroupLabel]
        let image = status ? UIImage(systemName: "circle")! : UIImage(systemName: "checkmark.circle")!
        let color = status ? FFResources.Colors.textColor : FFResources.Colors.detailTextColor
        let backgroundColor = status ? UIColor.systemBackground : UIColor.secondarySystemBackground
        let actionColor = status ? FFResources.Colors.activeColor : FFResources.Colors.darkPurple
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionFlipFromTop) { [unowned self] in
            self.layer.borderColor = actionColor.cgColor
            self.backgroundColor = backgroundColor
            completeStatusButton.setImage(image, for: .normal)
            completeStatusButton.tintColor = actionColor
            labels.forEach { label in
                label.textColor = color
            }
            isTrainingCompleted.toggle()
            delegate?.planStatusWasChanged(isTrainingCompleted, arrayPlace: completeStatusButton.tag)
        }
        
    }
    
    public func configureLabels(model: [FFTrainingPlanRealmModel],indexPath: IndexPath){
        let model = model[indexPath.row]
        let exercises: [String] = model.trainingExercises.compactMap { data -> String in
            return data.exerciseName
        }
        isTrainingCompleteSetup(!model.trainingCompleteStatus)
        let exerciseText = exercises.joined(separator: ", ")
        nameLabel.text = "Name: " + model.trainingName
        detailLabel.text = "Details: " + model.trainingNotes
        let dateString = DateFormatter.localizedString(from: model.trainingDate, dateStyle: .medium, timeStyle: .short)
        dateLabel.text = "Date: \(dateString)"
        muscleGroupLabel.text = exerciseText
        completeStatusButton.tag = indexPath.row
    }
    
    private func setupContentView(){
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = FFResources.Colors.griRed.cgColor
        completeStatusButton.addTarget(self, action: #selector(didTapSave), for: .primaryActionTriggered)
    }
    
    private func setupConstraints(){
        let stackView = UIStackView(arrangedSubviews: [nameLabel,detailLabel,dateLabel,muscleGroupLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.alignment = .fill
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
        
        let squareSize = contentView.frame.height / 3
        contentView.addSubview(completeStatusButton)
        completeStatusButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
            make.height.width.equalTo(squareSize)
        }
    }
}
