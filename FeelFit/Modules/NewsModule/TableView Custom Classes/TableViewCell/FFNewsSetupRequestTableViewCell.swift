//
//  FFNewsSetupRequestTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 25.10.2023.
//

import UIKit

class FFNewsSetupRequestTableViewCell: UITableViewCell {

    static let identifier = "FFNewsSetupRequestTableViewCell"
    
    var isCellOpened: Bool = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
         label.text = ""
        label.textColor = FFResources.Colors.textColor
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textAlignment = .left
        label.numberOfLines = 1
         return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
         label.text = ""
        label.textColor = FFResources.Colors.detailTextColor
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textAlignment = .left
        label.numberOfLines = 1
         return label
    }()
    
    private var disclosureImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = FFResources.Colors.activeColor
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraits()
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureText(title: String, statusTitle: String) {
        titleLabel.text = title
        statusLabel.text = statusTitle
    }
    
    func configureOpenCell(){
        titleLabel.text = nil
        statusLabel.text = nil
        disclosureImageView.image = nil
    }
    
    func setupImageView(){
        let image = isCellOpened ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.right")
        disclosureImageView.image = image
    }
    
    func setupConstraits(){
        let imageViewHeight = contentView.frame.size.height/2
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(5)
            make.width.equalTo(contentView.frame.size.width/1.5)
        }
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.width.equalTo(contentView.frame.size.width/2-imageViewHeight)
        }
        
        contentView.addSubview(disclosureImageView)
        disclosureImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(imageViewHeight-2)
        }
    }
    
}
