//
//  NewsPageTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 25.09.2023.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func buttonDidTapped(sender: UITableViewCell,status: Bool)
}

class NewsPageTableViewCell: UITableViewCell {
    
    weak var delegate: TableViewCellDelegate?

    static let identifier = "NewsPageTableViewCell"
    
    private var isAddedToFavourite: Bool = false
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: UIFont.systemFontSize,weight: .semibold)
        label.textColor = FFResources.Colors.textColor
        label.textAlignment = .left
        label.text = "Title"
        label.numberOfLines = 0
        return label
    }()
    
    let sourceLabel: UILabel = {
//        let underline = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        //подумать о подчеркивании ссылки для активного перехода или для копирования ссылки
        let label = UILabel()
         label.text = "Source"
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textAlignment = .left
        label.numberOfLines = 1
         return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
         label.text = "Author"
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = FFResources.Colors.textColor
         return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.textColor = FFResources.Colors.textColor
        label.font = .systemFont(ofSize: 14,weight: .thin)
         return label
    }()
    
    let newsImageView: UIImageView = {
       let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.backgroundColor = .systemIndigo
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "photo")
        image.tintColor = FFResources.Colors.tabBarBackgroundColor
        return image
    }()
    
    let newsAddFavouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = FFResources.Colors.activeColor
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = nil
        contentLabel.text = nil
        sourceLabel.text = nil
        authorLabel.text = nil
        newsImageView.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupConstraints()
        newsAddFavouriteButton.addTarget(self, action: #selector(didTapButtonTapped), for: .touchUpInside)
    }
    
    @objc private func didTapButtonTapped(sender: UIButton){
        isAddedToFavourite.toggle()
        
        let imageName = isAddedToFavourite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        newsAddFavouriteButton.setImage(image, for: .normal)
        delegate?.buttonDidTapped(sender: self, status: isAddedToFavourite)
    }
    
    func configureCell(model: Articles?){
        titleLabel.text = model?.title ?? nil
        contentLabel.text = model?.description ?? nil
        sourceLabel.text = "Source: " + (model?.source.name ?? "")
        authorLabel.text = "Author: " + (model?.author ?? "")
        
        if let image = model?.urlToImage {
            guard let url = URL(string: image) else { return }
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        } else {
            newsImageView.image = nil
        }
    }
    
    

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}

extension NewsPageTableViewCell {
    private func setupConstraints(){
        
        
        
        contentView.addSubview(newsImageView)
        
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel,newsAddFavouriteButton])
        titleStackView.axis = .horizontal
        titleStackView.alignment = .center
        titleStackView.distribution = .fillProportionally
        
        let secondaryStackView = UIStackView(arrangedSubviews: [sourceLabel,authorLabel])
        secondaryStackView.axis = .vertical
        secondaryStackView.alignment = .leading
        secondaryStackView.distribution = .fillProportionally
        
        contentView.addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(3)
            make.top.equalToSuperview().offset(3)
            make.height.equalToSuperview().dividedBy(6)
        }
        
        contentView.addSubview(secondaryStackView)
        secondaryStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(3)
            make.top.equalTo(titleStackView.snp.bottom).offset(3)
            make.height.equalToSuperview().dividedBy(4)
        }
        
        newsImageView.snp.makeConstraints { make in
            make.top.equalTo(secondaryStackView.snp.bottom).offset(3)
            make.bottom.leading.equalToSuperview().inset(3)
            make.width.equalToSuperview().dividedBy(4)
        }
    
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(secondaryStackView.snp.bottom).offset(3)
            make.leading.equalTo(newsImageView.snp.trailing).offset(3)
            make.trailing.bottom.equalToSuperview().inset(3)
        }
        
    }
}
