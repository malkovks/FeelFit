//
//  FFAddExerciseTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 08.12.2023.
//

import UIKit

class FFAddExerciseTableViewCell: UITableViewCell {
    
    static let identifier: String = "FFAddExerciseTableViewCell"
    
    var isHiddenDetailStack: Bool = false
    
    let mainTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.textLabelFont()
        label.textColor = FFResources.Colors.textColor
        label.textAlignment = .left
        return label
    }()
    
    let firstLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.detailLabelFont()
        label.textColor = FFResources.Colors.textColor
        label.textAlignment = .left
        return label
    }()
    
    let secondLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.detailLabelFont()
        label.textColor = FFResources.Colors.textColor
        label.textAlignment = .left
        return label
    }()
    
    let thirdLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.detailLabelFont()
        label.textColor = FFResources.Colors.textColor
        label.textAlignment = .left
        return label
    }()
    
    let exerciseImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = FFResources.Colors.textColor.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    func configureDetailCell(_ data: FFExerciseModelRealm){
        let weight = String(describing: data.exerciseWeight)
        let sets = String(describing: data.exerciseApproach)
        let repeats = String(describing: data.exerciseRepeat)
        firstLabel.text = "Weight: \(weight) kg."
        secondLabel.text = "Sets: \(sets) times."
        thirdLabel.text = "Repeats: \(repeats)"
    }
        
    func configureCell(indexPath: IndexPath, data: [FFExerciseModelRealm]){
        let exercise = data[indexPath.row]
        mainTextLabel.text = "Name: " + exercise.exerciseName.capitalized
        configureDetailCell(exercise)
        loadImage(exercise.exerciseImageLink) { [unowned self] image in
            DispatchQueue.main.async {
                self.exerciseImageView.image = image
            }
        }
    }
    
    private func loadImage(_ link: String,handler: @escaping ((UIImage) -> ())){
        guard let url = URL(string: link) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data, let image = UIImage(data: data){
                handler(image)
            } else {
                let image = UIImage(systemName: "figure.strengthtraining.traditional")!
                handler(image)
            }
        }
        task.resume()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        contentView.addSubview(exerciseImageView)
        exerciseImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(3)
            make.width.equalTo(contentView.snp.height).offset(-6)
        }
        contentView.addSubview(mainTextLabel)
        mainTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(3)
            make.leading.equalTo(exerciseImageView.snp.trailing).offset(3)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.5)
        }
        
        let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel, thirdLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(mainTextLabel.snp.bottom).offset(3)
            make.leading.equalTo(exerciseImageView.snp.trailing).offset(3)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.bottom.equalToSuperview().offset(-3)
        }
    }

}
