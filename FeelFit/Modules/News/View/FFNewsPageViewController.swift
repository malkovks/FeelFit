//
//  ViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 18.09.2023.
//

import UIKit
import SnapKit
import Alamofire


class FFNewsPageViewController: UIViewController,SetupViewController {
    
    private var viewModel: FFNewsPageViewModel!
    private var delegateClass: FFNewsTableViewDelegate?
    private var dataSourceClass: FFNewsTableViewDataSource?
    
    
    private var typeRequest = Request.RequestLoadingType.fitness
    private var filterRequest = Request.RequestSortType.publishedAt
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
            print(self.model.count)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            print(self.model.count)
        }
    }
    //MARK: - Targets
    @objc private func didTapOpenFavourite(){
        alertError(title: "Favourite View Controller", message: "This page in development", style: .alert, cancelTitle: "This is fine")
    }
    
    @objc private func didTapLoadMore(){
        var value = UserDefaults.standard.value(forKey: "pageNumberAPI") as! Int
        let pageNumber = value + 1
        UserDefaults.standard.setValue(pageNumber, forKey: "pageNumberAPI")
        viewModel!.requestData(pageNumber: pageNumber,type: typeRequest)
    }
    
    @objc private func didTapRefreshData(){
        loadingExactType(type: typeRequest,filter: filterRequest)
    }
    
    @objc private func didTapChangeSegment(){
//        switch newsSegmentalController.selectedSegmentIndex {
//        case 0:
////            loadingExactType(type: .fitness)
//        case 1:
////            loadingExactType(type: .health)
//        case 2:
////            loadingExactType(type: .trainings)
//        default:
//            break
//        }
    }
    
//    @objc private func didTapOpenNewsSettings(){
//        callUIMenu()
//    }
    
    //MARK: - Setup methods
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
        UserDefaults.standard.setValue(1, forKey: "pageNumberAPI")
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
        addNavigationBarButton(at: .left, title: nil, imageName: "gear", action: nil, menu: callUIMenu())
        addNavigationBarButton(at: .right, title: nil, imageName: "heart.fill", action: #selector(didTapOpenFavourite), menu: nil)
    }
    
    func callUIMenu() -> UIMenu {
        let filterActions = [
            UIAction(title: "Relevance") { [unowned self] _ in
                self.filterRequest = .relevancy
                loadingExactType(type: self.typeRequest, filter: self.filterRequest)
            },
            UIAction(title: "Popularity") { [unowned self] _ in
                self.filterRequest = .popularity
                loadingExactType(type: self.typeRequest, filter: self.filterRequest)
            },
            UIAction(title: "Published Date") { [unowned self] _ in
                self.filterRequest = .publishedAt
                loadingExactType(type: self.typeRequest, filter: self.filterRequest)
            },
        ]
        let divider = UIMenu(title: "Filter",image: UIImage(systemName: "line.3.horizontal.decrease.circle"),options: .singleSelection,children: filterActions)
        let requestActions = [ UIAction(title: "Health", handler: { [unowned self] _ in
            self.typeRequest = .health
        }),
                               UIAction(title: "Fitness", handler: { [unowned self] _ in
            self.typeRequest = .fitness
        }),
                               UIAction(title: "Gym", handler: { [unowned self] _ in
            self.typeRequest = .gym
        }),
                               UIAction(title: "Training", handler: { [unowned self] _ in
            self.typeRequest = .training
        }),
                               UIAction(title: "Sport", handler: { [unowned self] _ in
            self.typeRequest = .sport
        })]
        let secondDivider = UIMenu(title: "Request",image: UIImage(systemName: "list.bullet"),options: .singleSelection,children: requestActions)
        let items = [divider,secondDivider]
        return UIMenu(title: "Filter section",children: items)
    }
    
   
    
    func loadingExactType(type: Request.RequestLoadingType,filter: Request.RequestSortType){
        model = []
        viewModel!.requestData(type: type)
        viewModel.typeRequest = type
        viewModel.sortRequest = filter
        typeRequest = type
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
            alertError(title: "Error!", message: error?.localizedDescription, style: .alert, cancelTitle: "OK")
            spinner.stopAnimating()
            viewModel!.refreshControll.endRefreshing()
            return
        }
        
        loadDataButton.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width/2, height: 45)
        
        var newModel = [Articles]()
        for m in model ?? [Articles]() {
            if !m.source.name.elementsEqual("[Removed]") {
                newModel.append(m)
            }
        }
        
        
        self.model += newModel
        
        let uniqueItems = self.model.uniqueArray()
        DispatchQueue.main.async { [unowned self ] in
            self.model = uniqueItems
            self.reloadTableView(models: self.model)
            self.spinner.stopAnimating()
            self.viewModel!.refreshControll.endRefreshing()
            print(self.model.count)
        }
    }
    
    func reloadTableView(models: [Articles]) {
        dataSourceClass = FFNewsTableViewDataSource(with: models)
        delegateClass = FFNewsTableViewDelegate(with: self,model: models)
        tableView.dataSource = dataSourceClass
        tableView.delegate = delegateClass
        tableView.tableFooterView = loadDataButton
        tableView.reloadData()
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

//MARK: - Array extensions
extension Array where Element: Hashable {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for e in self {
            if !added.contains(e) {
                buffer.append(e)
                added.insert(e)
            }
        }
        return buffer
    }
}

public extension Array where Element: Hashable {
    func uniqueArray() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}




