//
//  NewsPageTableViewCell.swift
//  FeelFit
//
//  Created by Константин Малков on 25.09.2023.
//

import UIKit
import RealmSwift

protocol TableViewCellDelegate: AnyObject {
    func buttonDidTapped(sender: UITableViewCell,indexPath: IndexPath,status: Bool)
    func imageWasSelected(imageView: UIImageView?)
}



class FFNewsPageTableViewCell: UITableViewCell {
    
    weak var delegate: TableViewCellDelegate?

    static let identifier = "NewsPageTableViewCell"
    
    
    private var isAddedToFavourite: Bool = false
    
    //MARK: - UI elements
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: UIFont.systemFontSize,weight: .semibold)
        label.textColor = FFResources.Colors.textColor
        label.textAlignment = .left
        label.text = "Title"
        label.numberOfLines = 2
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    let publishDateLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.text = "Date"
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    let sourceLabel: UILabel = {
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
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "photo")
        image.tintColor = FFResources.Colors.activeColor
        return image
    }()
    
    let newsAddFavouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = FFResources.Colors.activeColor
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        setupView()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Target methods
    @objc private func didTapButtonTapped(sender: UIButton){
        isAddedToFavourite.toggle()
        print(newsAddFavouriteButton.tag)
        let indexPath = IndexPath(row: newsAddFavouriteButton.tag, section: 0)
        //Разобраться как передавать индекс строчки при нажатии на кнопку, чтобы затем можно было добавлять по индексу модель в избранное
        let imageName = isAddedToFavourite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        newsAddFavouriteButton.setImage(image, for: .normal)
        delegate?.buttonDidTapped(sender: self, indexPath: indexPath, status: isAddedToFavourite)
    }
    ///In progress
    @objc private func didTapImageView(){
        let image = newsImageView.image
        let imageView = UIImageView(image: image)
    }
    //MARK: - Setup methods
    private func setupView(){
        newsAddFavouriteButton.addTarget(self, action: #selector(didTapButtonTapped), for: .touchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        newsImageView.isUserInteractionEnabled = true
        newsImageView.addGestureRecognizer(gesture)
        contentView.layer.cornerRadius = 12
    }
    
    private func filterModel(model: Articles, indexPath: IndexPath){
        let realm = try! Realm()
        let object = realm.objects(FFNewsModelRealm.self).filter("newsURL = '\(model.url)'")
    }
    
    func configureCell(model: Articles?,indexPath: IndexPath){
        newsAddFavouriteButton.tag = indexPath.row
        titleLabel.text = model?.title ?? nil
        contentLabel.text = model?.description ?? nil
        sourceLabel.text = "Source: " + (model?.source.name ?? "")
        authorLabel.text = "Author: " + (model?.author ?? "")
        publishDateLabel.text = "Published: " + (model?.publishedAt.convertToStringData() ?? "")
        if let image = model?.urlToImage {
            guard let url = URL(string: image) else { return }
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        } else {
            newsImageView.image = UIImage(systemName: "photo")
        }
    }
}
//MARK: - Constraints
extension FFNewsPageTableViewCell {
    private func setupConstraints(){
        let titleAndReleaseStackView = UIStackView(arrangedSubviews: [titleLabel,publishDateLabel])
        titleAndReleaseStackView.axis = .vertical
        titleAndReleaseStackView.alignment = .leading
        titleAndReleaseStackView.distribution = .fill
        
        let secondaryStackView = UIStackView(arrangedSubviews: [sourceLabel])
        secondaryStackView.axis = .vertical
        secondaryStackView.alignment = .leading
        secondaryStackView.distribution = .fillProportionally
        
        contentView.addSubview(newsAddFavouriteButton)
        newsAddFavouriteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().offset(3)
            make.width.height.equalToSuperview().dividedBy(7)
        }
        
        contentView.addSubview(titleAndReleaseStackView)
        titleAndReleaseStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(3)
            make.trailing.equalTo(newsAddFavouriteButton.snp.leading).offset(3)
            make.top.equalToSuperview().offset(3)
//            make.width.equalTo(contentView.frame.width*5/6)
            make.height.equalToSuperview().dividedBy(3.5)
        }
        
        
        contentView.addSubview(secondaryStackView)
        secondaryStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(3)
            make.top.equalTo(titleAndReleaseStackView.snp.bottom).offset(3)
            make.height.equalToSuperview().dividedBy(5.5)
        }
        
        contentView.addSubview(newsImageView)
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
