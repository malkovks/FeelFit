//
//  FFExercisesMuscleTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 01.11.2023.
//

import UIKit

class FFExercisesMuscleTableViewCell: UITableViewCell {
    
    
    var indexPath: IndexPath!
    
    static let identifier = "FFExercisesMuscleTableViewCell"
    
    var statuses = [true,false,false,true,false,true,false,false,true,false,true,false,false,true,false,true,false,false,true,false]
    
    private let detailLabel: UILabel = {
       let label = UILabel()
        label.textColor = FFResources.Colors.detailTextColor
        label.font = .detailLabelFont()
        label.numberOfLines = 0
        label.textAlignment = .natural
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupImageViewInteraction()
//        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapOnImage(){
        print("Image print at \(indexPath.row) Status is \(statuses[indexPath.row])")
        let status = statuses[self.indexPath.row]
        if status {
            self.imageView?.image = UIImage(systemName: "heart.fill")
            statuses[indexPath.row].toggle()
        } else {
            self.imageView?.image = UIImage(systemName: "heart")
            statuses[indexPath.row].toggle()
        }
    }
    
    private func setupConstraints(){
        contentView.addSubview(detailLabel)
        guard let textLabel = textLabel else { return }
        guard let imageView = imageView else { return }
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom)
            make.leading.equalTo(imageView.snp.trailing)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupCell(){
        self.imageView?.layer.cornerRadius = 8
        self.imageView?.layer.masksToBounds = true
        self.layer.masksToBounds = true
        self.accessoryType = .disclosureIndicator
        self.textLabel?.numberOfLines = 1
        self.detailTextLabel?.numberOfLines = 0
        self.detailTextLabel?.isHidden = false
        self.imageView?.isUserInteractionEnabled = true
        
    }
    
    private func setupImageViewInteraction(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnImage))
        imageView?.addGestureRecognizer(gesture)
    }
    
    func configureView(keyName: String, exercise: Exercise,indexPath: IndexPath){
        self.textLabel?.text = exercise.exerciseName.capitalized
        self.detailTextLabel?.text = "Equipment - " + exercise.equipment.formatArrayText()
        self.imageView?.tintColor = FFResources.Colors.activeColor
        self.imageView?.tag = indexPath.row
        if statuses[indexPath.row] {
            self.imageView?.image = UIImage(systemName: "heart.fill")
        } else {
            self.imageView?.image = UIImage(systemName: "heart")
        }
        
    }
    
}
