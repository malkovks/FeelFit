//
//  FFExercisesCollectionViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 31.10.2023.
//

import UIKit

class FFExercisesCollectionViewCell: UICollectionViewCell {
    
    
    
    static let identifier = "ExerciseCell"
    
    var muscleDictionary = [
        "abdominals" : "Abdominals",
        "abductors" : "Abductors",
        "adductors" : "Adductors",
        "biceps" : "Biceps",
        "calves" : "Calves",
        "chest" : "Chest",
        "forearms" : "Forearms",
        "glutes" : "Glutes",
        "hamstrings" : "Hamstrings",
        "lats" : "Lats",
        "lower_back" : "Lower back",
        "middle_back" : "Middle back",
        "neck" : "Neck",
        "oblique" : "Obliques",
        "quadriceps" : "Quadriceps",
        "shoulders" : "Shoulders",
        "traps" : "Traps",
        "triceps" : "Triceps"
    ]
    
    private let muscleImageView: UIImageView = {
       let image = UIImageView(image: UIImage(named: "biceps"))
        image.backgroundColor = .systemFill
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let muscleTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .headerFont()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = FFResources.Colors.activeColor
        label.backgroundColor = FFResources.Colors.tabBarBackgroundColor
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupContentView()
    }
    
    private func setupConstraints() {
        contentView.addSubview(muscleImageView)
        muscleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        muscleImageView.addSubview(muscleTitleLabel)
        muscleTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(5)
            make.height.equalTo(contentView.frame.size.height/6)
        }
    }
    
    private func setupContentView(){
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = FFResources.Colors.activeColor
    }
    
    func configureCell(indexPath: IndexPath){
        let key = Array(muscleDictionary.keys.sorted())[indexPath.row]
        let value = muscleDictionary[key]
        muscleTitleLabel.text = value
        muscleImageView.image = UIImage(named: key)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
