//
//  FFCenteredTitleTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 06.04.2024.
//

import UIKit

class FFCenteredTitleTableViewCell: UITableViewCell {
    
    static let identifier = "FFCenteredTitleTableViewCell"
    
    var cellNameString: [[String]] = [[""],[""],["Load user's data"],["Exit from account"]]
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentConfiguration = nil
        backgroundConfiguration = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func configureCell(loaded isDataLoaded: Bool = false, indexPath: IndexPath){
        let value: String = cellNameString[indexPath.section][indexPath.row]
        if indexPath.section == 2 {
            let color = isDataLoaded ? UIColor.lightGray : UIColor.systemBackground
            let isCellEnable = !isDataLoaded
            setupDisplayText(text: value, backgroundColor: color, isUserInteractionEnabled: isCellEnable)
        } else {
            setupDisplayText(text: value)
        }
    }
    
    private func setupDisplayText(text: String, backgroundColor: UIColor = .systemBackground, isUserInteractionEnabled status: Bool = true){
        var backgroundConfig = backgroundConfiguration
        backgroundConfig?.backgroundColor = backgroundColor
        
        var config = defaultContentConfiguration()
        config.textProperties.font = UIFont.textLabelFont(size: 16, weight: .heavy)
        config.textProperties.alignment = .center
        config.textProperties.numberOfLines = 1
        config.textProperties.color = .customBlack
        config.text = text
        
        contentConfiguration = config
        backgroundConfiguration = backgroundConfig
        isUserInteractionEnabled = status
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
