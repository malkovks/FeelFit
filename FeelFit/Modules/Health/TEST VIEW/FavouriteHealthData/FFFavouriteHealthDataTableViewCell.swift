//
//  FFFavouriteHealthDataTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 10.02.2024.
//

import UIKit
import HealthKit

class FFFavouriteHealthDataTableViewCell: UITableViewCell {
    
    static let identifier = "FFFavouriteHealthDataTableViewCell"
    
    var isObjectSaved: Bool = false
    
    private let titleTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = FFResources.Colors.textColor
        label.font = UIFont.textLabelFont(size: 16, weight: .light, width: .standard)
        label.textAlignment = .left
        label.contentMode = .left
        label.numberOfLines = 1
        return label
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = FFResources.Colors.darkPurple
        button.backgroundColor = .clear
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewCell()
        setupConstraintsCell()
    }
    
    @objc private func didTapChangeStatus(_ sender: UIButton) {
        isObjectSaved.toggle()
        let image = isObjectSaved ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        UIView.transition(with: favouriteButton, duration: 0.2) { [weak self] in
            self?.favouriteButton.setImage(image, for: .normal)
        }
        
    }
    
    public func configureCell(_ indexPath: IndexPath,_ textID: [HKQuantityTypeIdentifier],_ status: Bool){
        let type = textID[indexPath.row]
        let text = getDataTypeName(type)
        titleTextLabel.text = text
        isObjectSaved = status
    }
    
    private func setupViewCell(){
        self.favouriteButton.addTarget(self, action: #selector(didTapChangeStatus), for: .primaryActionTriggered)
        self.accessoryView = favouriteButton as UIView
    }
    
    private func setupConstraintsCell(){
        contentView.addSubview(titleTextLabel)
        titleTextLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
