//
//  FFExercisesCollectionViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 31.10.2023.
//

import UIKit

class FFExercisesCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExerciseCell"
    
    private let muscleImageView: UIImageView = {
       let image = UIImageView(image: UIImage(named: "biceps"))
        image.backgroundColor = .systemFill
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let muscleTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .headerFont()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = FFResources.Colors.activeColor
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
            make.leading.trailing.bottom.equalToSuperview().inset(2)
            make.height.equalTo(contentView.frame.size.height/4)
        }
    }
    
    private func setupContentView(){
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor = .systemIndigo
    }
    
    func configureCell(text: String){
        muscleTitleLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
