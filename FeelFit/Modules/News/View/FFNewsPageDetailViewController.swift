//
//  FFNewsPageDetailViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 06.10.2023.
//

import UIKit

class FFNewsPageDetailViewController: UIViewController, SetupViewController {
    
    
    
    let model: Articles
    
    init(model: Articles) {
        self.model = model
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
        return image
    }()
    
    private let newsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemRed
        return scrollView
    }()
    
    private let newsTextView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .systemYellow
        text.textColor = .black
        text.isEditable = false
        text.isScrollEnabled = false
        text.isDirectionalLockEnabled = true
        return text
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addConstraints()
        setupView()
        setupNavigationController()
        setupImage()
    }
    
    func setupView() {
        view.backgroundColor = .lightGray
        newsTextView.text = model.description ?? "Some text"
        setupImage()
    }
    
    func setupImage(){
        guard let link = model.urlToImage, let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
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
        view.addSubview(newsScrollView)
        newsScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        newsScrollView.addSubview(newsImageView)
        newsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
        }
        
        newsScrollView.addSubview(newsTextView)
        newsTextView.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        newsScrollView.contentSize = CGSize(width: newsScrollView.frame.width, height: newsImageView.frame.height + newsTextView.frame.height + 20)
    }
}
