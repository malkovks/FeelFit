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
    private var delegateClass: FFNewsTableViewDelegate?
    private var dataSourceClass: FFNewsTableViewDataSource?
    
    var model: [Articles] = []
    //MARK: - UI elements
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = FFResources.Colors.activeColor
        return spinner
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(NewsPageTableViewCell.self, forCellReuseIdentifier: NewsPageTableViewCell.identifier)
        return table
    }()
    
    private let loadDataButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = FFResources.Colors.tabBarBackgroundColor.cgColor
        button.setTitle("Load more news", for: .normal)
        button.backgroundColor = FFResources.Colors.activeColor
        button.tintColor = FFResources.Colors.textColor
        button.addTarget(self, action: #selector(didTapLoadMore), for: .touchUpInside)
        return button
    }()
    
    //MARK: - View loading
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupView()
        setupNavigationController()
        setupSpinner()
        setupTableView()
        setupNewViewModel()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.viewModel!.requestData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    //MARK: - Targets
    @objc private func didTapOpenFavourite(){
        alertError(title: "Favourite View Controller", message: "This page in development", style: .alert, cancelTitle: "This is fine")
    }
    
    //CALL NEWS API
    @objc private func didTapOpenMenu(){
        viewModel!.requestData()
    }
    
    @objc private func didTapLoadMore(){
        let pageNumber = model.count/20+1
        viewModel!.uploadNewData(pageNumber: pageNumber)
    }
    
    //MARK: - Setup methods
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
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
        navigationController?.navigationBar.maximumContentSizeCategory = .small
        title = "News"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapOpenFavourite))
        addNavigationBarButton(at: .left, title: nil, imageName: "arrow.clockwise", action: #selector(didTapOpenMenu))
        addNavigationBarButton(at: .right, title: nil, imageName: "heart.fill", action: #selector(didTapOpenFavourite))
    }
    
    func setupTableView(){
        delegateClass = FFNewsTableViewDelegate(with: self,model: model)
        dataSourceClass = FFNewsTableViewDataSource(with: model)
        tableView.dataSource = dataSourceClass
        tableView.delegate = delegateClass
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
    }
}

extension FFNewsPageViewController: FFNewsTableViewCellDelegate {
    //функция отвечает за нажатие строки пользователем и возвращает индекс
    func selectedCell(indexPath: IndexPath) {
        
        print("\(indexPath.row) - Index Selected")
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
            loadDataButton.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width/2, height: 45)
            let newModel = model ?? [Articles]()
            self.model = newModel
            dataSourceClass = FFNewsTableViewDataSource(with: self.model)
            delegateClass = FFNewsTableViewDelegate(with: self,model: self.model)
            tableView.dataSource = dataSourceClass
            tableView.delegate = delegateClass
            tableView.tableFooterView = loadDataButton
        }
        tableView.reloadData()
        spinner.stopAnimating()
    }
    
    func didUpdateData(model: [Articles]?, error: Error?) {
        if error != nil {
            alertError(title: "Error parsing data", message: error?.localizedDescription, style: .alert, cancelTitle: "OK")
        } else {
            let newModel = model ?? [Articles]()
            self.model += newModel
            dataSourceClass = FFNewsTableViewDataSource(with: self.model)
            delegateClass = FFNewsTableViewDelegate(with: self,model: self.model)
            tableView.dataSource = dataSourceClass
            tableView.delegate = delegateClass
        }
        tableView.reloadData()
        spinner.stopAnimating()
    }
}


extension FFNewsPageViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(3)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}





