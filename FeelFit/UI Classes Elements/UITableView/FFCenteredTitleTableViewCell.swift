//
//  FFCenteredTitleTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 06.04.2024.
//

import UIKit

class FFCenteredTitleTableViewCell: UITableViewCell {
    
    static let identifier = "FFCenteredTitleTableViewCell"
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func configureCell(data: [[String:String]], indexPath: IndexPath){
        let dictionary = data[indexPath.section]
        let key: String = Array(dictionary.keys).sorted()[indexPath.row]
        
        setupDisplayText(text: key)
    }
    
    func setupDisplayText(text: String, backgroundColor: UIColor = .systemBackground, isUserInteractionEnabled status: Bool = true){
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
