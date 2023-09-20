//
//  ViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 18.09.2023.
//

import UIKit
import SnapKit

struct Model {
    let userName: String
    let userSecondName: String
    let userAge: Int
}

class FFNewsPageViewController: UIViewController,SetupViewController {
    
    var viewModel: ViewModel! {
        didSet {
            navigationItem.title = viewModel.user.userName + viewModel.user.userSecondName
        }
    }
    
    //MARK: - UI elements
    
    let label: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var sideBarMenu: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .done, target: self, action: #selector(didTapOpenMenu))
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Model(userName: "John", userSecondName: "Wick", userAge: 40)
        viewModel = ViewModel(user: user)
        viewModel.delegate = self
        setupConstraints()
        setupView()
        setupNavigationController()
    }
    //MARK: - Targets
    @objc private func didTapCheck(){
        viewModel.fetchData()
    }
    
    @objc private func didTapOpenMenu(){
        
        print("Button pressed")
        
    }
    
    //MARK: - Setup methods
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCheck))
//        navigationItem.leftBarButtonItem = sideBarMenu
        addNavigationBarButton(at: .left, title: nil, imageName: "trash.fill", action: #selector(didTapOpenMenu))
        addNavigationBarButton(at: .right, title: nil, imageName: "bookmark.fill", action: #selector(didTapCheck))
    }
    
    


}

extension FFNewsPageViewController: ViewModelDelegate {
    func didTapRegister(text: String) {
        label.text = text
    }
}

extension FFNewsPageViewController {
    private func setupConstraints(){
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}





