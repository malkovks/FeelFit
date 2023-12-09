//
//  FFTrainingPlanCollectionViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 11.11.2023.
//

import UIKit

class FFTrainingPlanCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrainingPlanCell"
    
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
    
    public func configureLabels(model: FFTrainingPlanRealmModel){
        nameLabel.text = model.trainingName
        detailLabel.text = model.trainingLocation
        dateLabel.text = String(describing: model.trainingDate)
        muscleGroupLabel.text = model.trainingExercises.first?.exerciseMuscle
    }
    
    private func setupContentView(){
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.backgroundColor = FFResources.Colors.backgroundColor
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
    }
}
