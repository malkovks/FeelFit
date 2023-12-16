//
//  FFMuscleGroupTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 04.12.2023.
//

import UIKit
import RealmSwift

class FFMuscleGroupTableViewCell: UITableViewCell {
    
    let mainTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.textLabelFont(size: 24)
        label.textColor = FFResources.Colors.textColor
        return label
    }()
    
    let muscleImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.tintColor = FFResources.Colors.activeColor
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0.5
        image.layer.borderColor = FFResources.Colors.textColor.cgColor
        image.image = UIImage(systemName: "figure.highintensity.intervaltraining")
        return image
    }()
    
    let downloadIndicatorImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemGray3
        return image
    }()
    
    static let identifier = "FFMuscleGroupTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellConstraints()
        setupCell()
    }
    
    func configureCell(indexPath: IndexPath, data: [String : String]){
        let key = Array(data.keys.sorted())[indexPath.row]
        let valueName = data[key]
        muscleImageView.image = UIImage(named: key) ?? UIImage(systemName: "figure.run")
        mainTextLabel.text = valueName
        checkStatusCode(key: key)
    }
   
    private func checkStatusCode(key: String){
        let formatKey = key.replacingOccurrences(of: "%20", with: " ")
        let secondFormatKey = formatKey.replacingOccurrences(of: "_", with: " ")
        let realm = try! Realm()
        let value = realm.objects(FFExerciseModelRealm.self).filter("exerciseMuscle == %@",secondFormatKey)
        let status = value.count > 0 ? true : false
        if status {
            downloadIndicatorImageView.image = UIImage(systemName: "arrow.down.circle.fill")
        } else {
            downloadIndicatorImageView.image = nil
        }
    }
    
    private func setupCell(){
        self.accessoryType = .disclosureIndicator
    }
    
    private func setupCellConstraints(){
        let height = contentView.snp.height
        
        contentView.addSubview(muscleImageView)
        muscleImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(3)
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(height).multipliedBy(0.9)
        }
        
        contentView.addSubview(mainTextLabel)
        mainTextLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(3)
            make.leading.equalTo(muscleImageView.snp.trailing).offset(2)
            make.trailing.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(downloadIndicatorImageView)
        downloadIndicatorImageView.snp.makeConstraints { make in
            let size = contentView.frame.height/1.5
            make.trailing.equalToSuperview().inset(size)
            make.top.bottom.equalToSuperview().inset(20)
            make.height.width.equalTo(15)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
