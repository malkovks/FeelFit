//
//  ViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 18.09.2023.
//

import UIKit
import SnapKit



class FFNewsPageViewController: UIViewController,SetupViewController {
    
    private var viewModel: FFNewsPageViewModel!
    private var delegateClass: FFNewsTableViewDelegate?
    private var dataSourceClass: FFNewsTableViewDataSource?
    
    
    private var typeRequest = RequestLoadingType.fitness
    var model: [Articles] = []
    //MARK: - UI elements
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = FFResources.Colors.activeColor
        return spinner
    }()
    
    private let tableView: UITableView = {
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
    
    private let newsSegmentalController: UISegmentedControl = {
       let controller = UISegmentedControl(items: ["Fitness","Health","Trainings"])
        controller.selectedSegmentIndex = 0
        controller.tintColor = FFResources.Colors.activeColor
        controller.selectedSegmentTintColor = FFResources.Colors.activeColor
        controller.backgroundColor = FFResources.Colors.tabBarBackgroundColor
        return controller
    }()
    
    //MARK: - View loading
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupView()
        setupNavigationController()
        setupSpinner()
        setupNewViewModel()
        setupTableView()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.viewModel!.requestData()
        }
    }
    //MARK: - Targets
    @objc private func didTapOpenFavourite(){
        alertError(title: "Favourite View Controller", message: "This page in development", style: .alert, cancelTitle: "This is fine")
    }
    
    //CALL NEWS API
    @objc private func didTapOpenMenu(){
        viewModel!.requestData(type: typeRequest)
    }
    
    @objc private func didTapLoadMore(){
        let pageNumber = model.count/20+1
        viewModel!.requestData(pageNumber: pageNumber,type: typeRequest)
    }
    
    @objc private func didTapRefreshData(){
        viewModel!.requestData()
    }
    
    @objc private func didTapChangeSegment(){
        switch newsSegmentalController.selectedSegmentIndex {
        case 0:
            viewModel!.requestData(type: .fitness)
            viewModel.typeRequest = .fitness
            typeRequest = .fitness
        case 1:
            viewModel!.requestData(type: .health)
            viewModel.typeRequest = .health
            typeRequest = .health
        case 2:
            viewModel!.requestData(type: .trainings)
            viewModel.typeRequest = .trainings
            typeRequest = .trainings
        default:
            break
        }
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
        
        
        tableView.tableHeaderView = newsSegmentalController
        tableView.refreshControl = viewModel.refreshControll
        viewModel.refreshControll.addTarget(self, action: #selector(didTapRefreshData), for: .valueChanged)
        newsSegmentalController.addTarget(self, action: #selector(didTapChangeSegment), for: .valueChanged)
    }
}
/// отвечает за нажатие строки пользователем и возвращает индекс
extension FFNewsPageViewController: FFNewsTableViewCellDelegate {
    
    func selectedCell(indexPath: IndexPath) {
        
        print("\(indexPath.row) - Index Selected")
    }
}
///view model delegate
extension FFNewsPageViewController: FFNewsPageDelegate {
    func willLoadData() {
        spinner.startAnimating()
        viewModel!.refreshControll.beginRefreshing()
    }
    //доделать запрос чтобы он не добавлял по 20 новых запросов одинаково, удалял старые и добавлял новые
    func didLoadData(model: [Articles]?,error: Error?) {
        guard error == nil else {
            alertError(title: "Error parsing data", message: error?.localizedDescription, style: .alert, cancelTitle: "OK")
            return
        }
        loadDataButton.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width/2, height: 45)
        let newModel = model ?? [Articles]()
        self.model += newModel
        dataSourceClass = FFNewsTableViewDataSource(with: self.model)
        delegateClass = FFNewsTableViewDelegate(with: self,model: self.model)
        tableView.dataSource = dataSourceClass
        tableView.delegate = delegateClass
        tableView.tableFooterView = loadDataButton
        tableView.reloadData()
        spinner.stopAnimating()
        viewModel!.refreshControll.endRefreshing()
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(3)
            make.leading.trailing.equalToSuperview().inset(3)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}





