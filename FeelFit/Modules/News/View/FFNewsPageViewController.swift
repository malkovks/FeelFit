//
//  ViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 18.09.2023.
//

import UIKit
import SnapKit


//доделать класс в соответствии с примером
// вставить таблицу для примерного отображения данных
//модель инициализировать из viewModel во вью при нажатии кнопки
class FFNewsPageViewController: UIViewController,SetupViewController {
    
    private var viewModel: FFNewsPageViewModel!
    
    //MARK: - UI elements
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = FFResources.Colors.activeColor
        return spinner
    }()
    
    private let customView = FFNewsPageView()
    
    //MARK: - View loading
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupView()
        setupNavigationController()
        setupSpinner()
        setupNewViewModel()
    }
    //MARK: - Targets
    @objc private func didTapCheck(){
    
        viewModel!.requestData()
    }
    
    //CALL NEWS API
    @objc private func didTapOpenMenu(){
        
    }
    
    //MARK: - Setup methods
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupNewViewModel(){
        viewModel = FFNewsPageViewModel()
        viewModel.delegate = self
    }
    
    func setupSpinner() {
        view.addSubview(spinner)
        spinner.center = view.center
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "News"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCheck))
        addNavigationBarButton(at: .left, title: nil, imageName: "arrow.clockwise", action: #selector(didTapOpenMenu))
        addNavigationBarButton(at: .right, title: nil, imageName: "heart.fill", action: #selector(didTapCheck))
    }
}

extension FFNewsPageViewController: FFNewsPageDelegate {
    func willLoadData() {
        spinner.startAnimating()
    }
    
    func didLoadData(model: [Articles]?,error: Error?) {
        if error != nil {
            alertError(title: "Error parsing data", message: error?.localizedDescription, style: .alert, cancelTitle: "OK")
        } else {
            dump(model)
        }
        spinner.stopAnimating()
        
    }
}


extension FFNewsPageViewController {
    private func setupConstraints(){
        view.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        

    }
}





