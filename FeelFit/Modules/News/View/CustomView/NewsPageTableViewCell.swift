//
//  NewsPageTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 25.09.2023.
//

import UIKit

class NewsPageTableViewCell: UITableViewCell {

    static let identifier = "NewsPageTableViewCell"
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.backgroundColor = .systemMint
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
        label.backgroundColor = .systemIndigo
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
        label.backgroundColor = .yellow
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = FFResources.Colors.textColor
         return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.textColor = FFResources.Colors.textColor
        label.font = .systemFont(ofSize: 16,weight: .light)
         label.text = "Content"
         return label
    }()
    
    let newsImageView: UIImageView = {
       let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        image.backgroundColor = .systemIndigo
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let newsAddFavouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.image = UIImage(systemName: "heart")
        button.backgroundColor = .systemRed
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupConstraints()
    }
    
    func configureCell(model: Articles?){
        titleLabel.text = model?.title
        contentLabel.text = model?.content
        
        if let image = model?.urlToImage {
            guard let url = URL(string: image) else { return }
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NewsPageTableViewCell {
    private func setupConstraints(){
        contentView.addSubview(newsImageView)
        newsImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(5)
            make.width.equalTo(self.snp.height).inset(5)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.leading.equalTo(newsImageView.snp.trailing).offset(3)
            make.trailing.equalToSuperview().offset(23)
            make.height.equalToSuperview().dividedBy(7)
        }
        contentView.addSubview(newsAddFavouriteButton)
        newsAddFavouriteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().offset(3)
            make.leading.equalTo(titleLabel.snp.trailing).offset(3)
            make.width.equalTo(20)
        }
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalTo(newsImageView.snp.trailing).offset(3)
            make.trailing.bottom.equalToSuperview().inset(3)
        }
        
    }
}
