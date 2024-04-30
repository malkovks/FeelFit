//
//  FFUserProfileTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 28.04.2024.
//

import UIKit

class FFUserProfileTableViewCell: UITableViewCell {
    
    static let identifier = "FFFUserProfileTableViewCell"
    
    private let userTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.font = UIFont.textLabelFont(size: 16,weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    func configureCell(indexPath: IndexPath,textArray: [[String]]){
        let text = textArray[indexPath.section][indexPath.row]
        userTitleLabel.text = text
        switch indexPath.section {
        case 3:
            userTitleLabel.textColor = .systemRed
            accessoryType = .none
            userTitleLabel.textAlignment = .center
        default:
            break
        }
    }
    
    private func setupCell(){
        backgroundColor = .systemBackground
        accessoryType = .disclosureIndicator
        setupConstraints()
    }
    
    private func setupConstraints(){
        self.contentView.addSubview(userTitleLabel)
        userTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userTitleLabel.text = nil
    }

}
