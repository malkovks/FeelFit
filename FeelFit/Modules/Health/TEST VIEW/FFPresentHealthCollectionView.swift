//
//  FFPresentHealthCollectionView.swift
//  FeelFit
//
//  Created by Константин Малков on 04.02.2024.
//

import UIKit

class FFPresentHealthCollectionView: UIViewController, SetupViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    @objc private func didTapPresentUserProfile(){
        print("Present user profile")
    }
    
    func setupView() {
        view.backgroundColor = .darkPurple
        setupNavigationController()
        setupViewModel()
        setupConstraints()
    }
    
    func setupNavigationController() {
        let height = (navigationController?.navigationBar.frame.height) ?? CGFloat(50)
        let customView = FFNavigationControllerCustomView()
        customView.configureView(title: "Summary")
        customView.autoresizingMask = .flexibleWidth
        
        
//        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = customView

    }
    
    func setupViewModel() {
        
    }

}

private extension FFPresentHealthCollectionView {
    func setupConstraints(){
        
    }
}

fileprivate class FFNavigationControllerCustomView: UIView {
    let navigationTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.headerFont(size: 30)
        label.textAlignment = .left
        label.contentMode = .left
        label.numberOfLines = 1
        label.textColor = FFResources.Colors.textColor
        return label
    }()
    
    let navigationButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "user"), for: .normal)
        button.tintColor = FFResources.Colors.activeColor
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    @objc private func didTapPushButton(){
        print("Button pushed")
    }
    
    func configureView(title text: String,_ image: UIImage = UIImage(systemName: "person")! ){
        navigationTitleLabel.text = text
        navigationButton.setImage(image, for: .normal)
    }
    
    private func setupView(){
        setupConstraints()
        navigationButton.addTarget(self, action: #selector(didTapPushButton), for: .primaryActionTriggered)
        self.frame = CGRect(x: 0, y: 0, width: 500, height: 100)
        self.backgroundColor = .red
    }
    
    private func setupConstraints(){
        
//        let stackView = UIStackView(arrangedSubviews: [navigationTitleLabel,navigationButton])
//        stackView.axis = .horizontal
//        stackView.distribution = .fill
//        stackView.spacing = 10
//        self.addSubview(stackView)
//        stackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        self.addSubview(navigationTitleLabel)
        navigationTitleLabel.backgroundColor = .yellow
        navigationTitleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(400)
        }
        
        self.addSubview(navigationButton)
        navigationButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(navigationTitleLabel.snp.trailing).offset(3)
            make.width.equalToSuperview().multipliedBy(0.09)
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
