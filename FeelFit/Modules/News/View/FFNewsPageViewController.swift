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
    var model: [Articles] = []
    
    var newsPageDataSource: UITableViewDataSource? {
        didSet {
            self.tableView.dataSource = newsPageDataSource
            self.tableView.reloadData()
        }
    }
    
    //MARK: - UI elements
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = FFResources.Colors.activeColor
        return spinner
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(NewsPageTableViewCell.self, forCellReuseIdentifier: NewsPageTableViewCell.identifier)
        return table
    }()
    
//    private let customView = FFNewsPageView()
    
    //MARK: - View loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        setupView()
        setupNavigationController()
        setupSpinner()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNewViewModel()
        viewModel!.requestData()
        self.newsPageDataSource = FFNewsTableViewDataSource(cellDataModel: model)
    }
    //MARK: - Targets
    @objc private func didTapOpenFavourite(){
        alertError(title: "Favourite View Controller", message: "This page in development", style: .alert, cancelTitle: "This is fine")
    }
    
    //CALL NEWS API
    @objc private func didTapOpenMenu(){
        viewModel!.requestData()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapOpenFavourite))
        addNavigationBarButton(at: .left, title: nil, imageName: "arrow.clockwise", action: #selector(didTapOpenMenu))
        addNavigationBarButton(at: .right, title: nil, imageName: "heart.fill", action: #selector(didTapOpenFavourite))
    }
    
    func setupTableView(){
        let delegateClass = FFNewsTableViewDelegate()
        let dataSourceClass = FFNewsTableViewDataSource()
        tableView.dataSource = dataSourceClass
        tableView.delegate = delegateClass
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
            self.model = model!
//            let dataSource = FFNewsTableViewDataSource()
//            dataSource.cellDataModel = model!
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }
        spinner.stopAnimating()
    }
}


extension FFNewsPageViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}





