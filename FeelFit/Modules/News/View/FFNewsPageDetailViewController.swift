//
//  FFNewsPageDetailViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 06.10.2023.
//

import UIKit

class FFNewsPageDetailViewController: UIViewController, SetupViewController {
    
    
    
    let model: Articles
    let defaultImage: UIImage
    
    init(model: Articles, image: UIImage = UIImage(systemName: "photo")!) {
        self.model = model
        self.defaultImage = image
        super.init(nibName: nil, bundle: nil)
        self.title = model.source.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let newsImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.tintColor = FFResources.Colors.activeColor
        return image
    }()
    
    private let newsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemRed
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let newsTextView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .systemYellow
        text.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        text.textAlignment = .natural
        text.textColor = .black
        text.isEditable = false
        text.isScrollEnabled = true
        text.isDirectionalLockEnabled = true
        text.textContainer.maximumNumberOfLines = 0
        return text
    }()
    
    private let newsTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = FFResources.Colors.textColor
        label.backgroundColor = .secondarySystemBackground
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let newsAuthorLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = FFResources.Colors.textColor
        label.backgroundColor = .secondarySystemBackground
        label.textAlignment = .left
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let newsPublishedLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textColor = FFResources.Colors.detailTextColor
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let newsSourceLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = FFResources.Colors.activeColor
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addConstraints()
        setupView()
        setupNavigationController()
    }
    
    func setupView() {
        view.backgroundColor = .lightGray
        newsTextView.text = model.description ?? ""
        newsTitleLabel.text = model.title
        newsSourceLabel.text = model.source.name
        newsAuthorLabel.text = model.author ?? ""
        newsPublishedLabel.text = model.publishedAt.convertToStringData()
        setupImage()
    }
    
    func setupImage(){
        guard let link = model.urlToImage, let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.newsImageView.image = self?.defaultImage
                return
            }
            DispatchQueue.main.async {
                self?.newsImageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    func setupNavigationController() {
        
    }
}

extension FFNewsPageDetailViewController {
    private func addConstraints(){
//        view.addSubview(newsScrollView)
//        newsScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-2)
//        newsScrollView.contentSize = CGSize(width: view.frame.size.width, height: 1200)
        
        let mainStackView = UIStackView(arrangedSubviews: [newsTitleLabel,newsSourceLabel,newsAuthorLabel,newsPublishedLabel])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .leading
        mainStackView.distribution = .equalCentering
        
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
//            make.leading.trailing.equalTo(view.frame.size.width).inset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.size.width-20)
            make.height.equalToSuperview().dividedBy(5)
        }
        
        view.addSubview(newsImageView)
        newsImageView.layer.cornerRadius = 12
        newsImageView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
        }
        
        view.addSubview(newsTextView)
        newsTextView.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.frame.size.width).inset(20)
            make.width.equalTo(view.frame.size.width).inset(20)
            make.height.equalToSuperview().dividedBy(2)
        }
//
//        newsScrollView.addSubview(newsLabel)
//        newsLabel.snp.makeConstraints { make in
//            make.top.equalTo(newsImageView.snp.bottom).offset(10)
//            make.width.equalTo(view.frame.size.width).inset(20)
//            make.bottom.equalToSuperview().inset(10)
//        }
//        
//        newsScrollView.addSubview(secondNewsLabel)
//        secondNewsLabel.snp.makeConstraints { make in
//            make.top.equalTo(newsScrollView.snp.bottom).offset(-50)
//            make.width.equalTo(newsScrollView.snp.width).inset(20)
//            make.height.equalTo(40)
//        }
//        newsScrollView.contentSize = CGSize(width: view.frame.width, height: 1200)
    }
}
