//
//  FFAddExerciseTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 08.12.2023.
//

import UIKit

class FFAddExerciseTableViewCell: UITableViewCell {
    
    static let identifier: String = "FFAddExerciseTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    func setupCell(){
        textLabel?.font = UIFont.textLabelFont(size: 18)
        detailTextLabel?.font = UIFont.detailLabelFont()
        
    }
        
    func configureCell(indexPath: IndexPath, data: [Exercise]){
        let exercise = data[indexPath.row]
        self.textLabel?.text = "Name: " + exercise.exerciseName.capitalized
        self.detailTextLabel?.text = "Muscle: " + exercise.muscle.capitalized
        loadImage(exercise.imageLink) { [unowned self] image in
            DispatchQueue.main.async {
                self.imageView?.image = image
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

}
