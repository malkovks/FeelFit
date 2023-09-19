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
    
    var sideBarMenuVC = FFSideBarMenuViewController()
    var isSidebarMenuVisible: Bool = false
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
        
        
        if isSidebarMenuVisible {
                // Hide the menu
                UIView.animate(withDuration: 0.3, animations: {
                    self.sideBarMenuVC.view.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height)
                }) { _ in
                    self.sideBarMenuVC.removeFromParent()
                    self.sideBarMenuVC.view.removeFromSuperview()
                }
            } else {
                // Show the menu
                sideBarMenuVC = FFSideBarMenuViewController()
                addChild(sideBarMenuVC)
                view.addSubview(sideBarMenuVC.view)
                
                sideBarMenuVC.view.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width * 0.8, height: view.frame.height)
                
                UIView.animate(withDuration: 0.3) {
                    self.sideBarMenuVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height)
                }
            }

//        let menu = FFSideBarMenuViewController()
//        var viewIsOpened: Bool = false
//        addChild(menu)
//        view.addSubview(menu.view)
//        menu.view.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width * 0.8, height: view.frame.height)
//
//        if !viewIsOpened {
//            UIView.animate(withDuration: 0.3) {
//                menu.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height)
//            } completion: { _ in
//                self.addChild(menu)
//                self.view.addSubview(menu.view)
//                viewIsOpened = true
//            }
//        } else {
//            UIView.animate(withDuration: 0.3, animations: {
//                menu.view.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height)
//            }) { _ in
//                viewIsOpened = false
//                menu.removeFromParent()
//                menu.view.removeFromSuperview()
//            }
//        }
    }
    
    //MARK: - Setup methods
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupNavigationController() {
        title = "Test navigation"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCheck))
        navigationItem.leftBarButtonItem = sideBarMenu
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





