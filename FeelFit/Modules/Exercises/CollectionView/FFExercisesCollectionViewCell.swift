//
//  FFExercisesCollectionViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 31.10.2023.
//

import UIKit
import RealmSwift

class FFExercisesCollectionViewCell: UICollectionViewCell {
    
    private let realm = try! Realm()
    
    static let identifier = "ExerciseCell"
    
    var muscleDictionary = [
        "abs" : "Abdominals",
        "abductors" : "Abductors",
        "adductors" : "Adductors",
        "biceps" : "Biceps",
        "calves" : "Calves",
        "cardiovascular_system" : "Circulatory System",
        "delts" : "Delts",
        "forearms" : "Forearms",
        "glutes" : "Glutes",
        "hamstrings" : "Hamstrings",
        "lats" : "Lats",
        "pectorals" : "Pectorals",
        "neck" : "Neck",
        "quads" : "Quadriceps",
        "serratus_anterior" : "Serratus Anterior",
        "spine" : "Spine",
        "traps" : "Traps",
        "triceps" : "Triceps",
        "upper_back" : "Upper Back"
    ]
    
    private let muscleImageView: UIImageView = {
       let image = UIImageView(image: UIImage(named: "biceps"))
        image.backgroundColor = FFResources.Colors.activeColor
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let statusImageView: UIImageView = {
       let image = UIImageView(image: UIImage(systemName: "arrow.down.circle.fill"))
        image.contentMode = .scaleAspectFit
        image.tintColor = FFResources.Colors.textColor
        return image
    }()
    
    let muscleTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .headerFont()
        label.textAlignment = .center
        label.contentMode = .scaleAspectFit
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
        
        muscleImageView.addSubview(statusImageView)
        statusImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
            make.height.width.equalTo(20)
        }
    }
    
    private func checkStatusCode(_ key: String){
        let formatKey = key.replacingOccurrences(of: "%20", with: " ")
        let fKey = formatKey.replacingOccurrences(of: "_", with: " ")
        let realm = try! Realm()
        let value = realm.objects(FFExerciseModelRealm.self).filter("exerciseMuscle == %@", fKey)
        let status = value.count > 0 ? true : false
        if status {
            statusImageView.image = UIImage(systemName: "arrow.down.circle.fill")
        } else {
            statusImageView.image = nil
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
        checkStatusCode(key)
        muscleTitleLabel.text = value
        muscleImageView.image = UIImage(named: key)
        FFExerciseStoreManager.shared.checkDuplicates(key)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
