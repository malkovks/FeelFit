//
//  FFNewsPageDetailViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 06.10.2023.
//

import UIKit
import SafariServices

class FFNewsPageDetailViewController: UIViewController, SetupViewController {
    
    var viewModel: FFNewsDetailViewModel?
    
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
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.tintColor = FFResources.Colors.activeColor
        return image
    }()
    
    private let newsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let newsTextView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .clear
        text.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        text.textAlignment = .natural
        text.textColor = FFResources.Colors.textColor
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
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let newsAuthorLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = FFResources.Colors.textColor
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let newsPublishedLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textColor = FFResources.Colors.detailTextColor
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let newsSourceButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .bordered()
        button.configuration?.imagePadding = 1
        button.setImage(UIImage(systemName: "link.circle"), for: .normal)
        button.configuration?.imagePlacement = .trailing
        button.backgroundColor = .clear
        button.configuration?.baseForegroundColor = FFResources.Colors.activeColor
        button.configuration?.baseBackgroundColor = .clear
        button.sizeToFit()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel = FFNewsDetailViewModel()
        addConstraints()
        setupView()
        setupNavigationController()
    }
    
    @objc private func didTapPushedButton(){
        guard let url = URL(string: model.url) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapAddFavourite(){
        
    }
    
    @objc private func didTapDismiss(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
        setupDetailNews()
        setupImage()
    }
    
    func setupDetailNews(){
        newsSourceButton.setTitle(model.source.name, for: .normal)
        newsSourceButton.addTarget(self, action: #selector(didTapPushedButton), for: .touchUpInside)
        let author = String(describing: model.author ?? "")
        let publishedAt = String(describing: model.publishedAt.convertToStringData())
        let button = UIButton()
        button.setImage(UIImage(systemName: "link.circle"), for: .normal)
        button.tintColor = FFResources.Colors.activeColor
        
        guard var description = model.description else { return }
        print(description)
        //Не работает корректно, доделать
        if description.suffix(3) == "..." {
            description += "\nContinued via link"
        }
        
        newsTextView.text = description
        newsTextView.inputAccessoryView = button as UIView
        newsTitleLabel.text = model.title
        newsAuthorLabel.text = "Author: \(author)"
        newsPublishedLabel.text = "Published: \(publishedAt)"
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
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: nil, imageName: "arrow.left", action: #selector(didTapDismiss), menu: nil)
        navigationItem.rightBarButtonItem =  addNavigationBarButton(title: nil, imageName: "heart", action: #selector(didTapAddFavourite), menu: nil)
    }
}

extension FFNewsPageDetailViewController {
    private func addConstraints(){
        
        let mainStackView = UIStackView(arrangedSubviews: [newsTitleLabel,newsSourceButton,newsAuthorLabel,newsPublishedLabel])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .fill
        mainStackView.distribution = .equalCentering
        
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.size.width-20)
            make.height.equalToSuperview().dividedBy(5)
        }
        
        view.addSubview(newsImageView)
        newsImageView.layer.cornerRadius = 12
        newsImageView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().dividedBy(4)
        }
        
        view.addSubview(newsTextView)
        newsTextView.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.frame.size.width).inset(20)
            make.width.equalTo(view.frame.size.width).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
}

#Preview {
    FFNewsPageViewController()
}