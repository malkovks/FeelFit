//
//  ViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 18.09.2023.
//

import UIKit
import SnapKit
import Alamofire
import SafariServices


class FFNewsPageViewController: UIViewController,SetupViewController {
    
    private var viewModel: FFNewsPageViewModel!
    private var delegateClass: FFNewsTableViewDelegate?
    private var dataSourceClass: FFNewsTableViewDataSource?
    
    private var typeRequest = UserDefaults.standard.string(forKey: "typeRequest") ?? "fitness"
    private var filterRequest = UserDefaults.standard.string(forKey: "filterRequest") ?? "publishedAt"
    private var localeRequest = UserDefaults.standard.string(forKey: "localeRequest") ?? "en"
    var model: [Articles] = []
    //MARK: - UI elements
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = FFResources.Colors.activeColor
        return spinner
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(FFNewsPageTableViewCell.self, forCellReuseIdentifier: FFNewsPageTableViewCell.identifier)
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
        setupNewViewModel()
        setupTableView()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){ [unowned self] in
            self.viewModel!.requestData(type: self.typeRequest, filter: self.filterRequest)
        }
    }
    //MARK: - Targets
    @objc private func didTapOpenFavourite(){
        let vc = FFNewsFavouriteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLoadMore(){
        var value = UserDefaults.standard.value(forKey: "pageNumberAPI") as! Int
        let pageNumber = value + 1
        UserDefaults.standard.setValue(pageNumber, forKey: "pageNumberAPI")
        viewModel!.requestData(pageNumber: pageNumber,type: typeRequest, filter: filterRequest)
    }
    
    @objc private func didTapRefreshData(){
        loadingExactType(type: typeRequest,filter: filterRequest,locale: localeRequest)
    }
    
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
        tableView.refreshControl = viewModel.refreshControll
        viewModel.refreshControll.addTarget(self, action: #selector(didTapRefreshData), for: .valueChanged)
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
    //MARK: - ДОДЕЛАТЬ UIMenu
    func callUIMenu() -> UIMenu {
        let filterActions = [
            UIAction(title: "Relevance") { _ in
                self.filterRequest = Request.RequestSortType.relevancy.rawValue
                UserDefaults.standard.setValue(Request.RequestSortType.relevancy.rawValue, forKey: "filterRequest")
            },
            UIAction(title: "Popularity") { [unowned self] _ in

                self.filterRequest = Request.RequestSortType.popularity.rawValue
                UserDefaults.standard.setValue(Request.RequestSortType.popularity.rawValue, forKey: "filterRequest")
            },
            UIAction(title: "Published Date") { [unowned self] _ in
                self.filterRequest = Request.RequestSortType.publishedAt.rawValue
                UserDefaults.standard.setValue(Request.RequestSortType.publishedAt.rawValue, forKey: "filterRequest")
            },
        ]
        let divider = UIMenu(title: "Filter",image: UIImage(systemName: "line.3.horizontal.decrease.circle"),options: .singleSelection,children: filterActions)
        
        let requestActions = [ UIAction(title: "Health", handler: { [unowned self] _ in
            self.typeRequest = Request.RequestLoadingType.health.rawValue
            UserDefaults.standard.setValue(Request.RequestLoadingType.health.rawValue, forKey: "typeRequest")
        }),
                               UIAction(title: "Fitness", handler: { [unowned self] _ in
            self.typeRequest = Request.RequestLoadingType.fitness.rawValue
            UserDefaults.standard.setValue(Request.RequestLoadingType.fitness.rawValue, forKey: "typeRequest")
        }),
                               UIAction(title: "Gym", handler: { [unowned self] _ in
            self.typeRequest = Request.RequestLoadingType.gym.rawValue
            UserDefaults.standard.setValue(Request.RequestLoadingType.gym.rawValue, forKey: "typeRequest")
        }),
                               UIAction(title: "Training", handler: { [unowned self] _ in
            self.typeRequest = Request.RequestLoadingType.training.rawValue
            UserDefaults.standard.setValue(Request.RequestLoadingType.training.rawValue, forKey: "typeRequest")
        }),
                               UIAction(title: "Sport", handler: { [unowned self] _ in
            self.typeRequest = Request.RequestLoadingType.sport.rawValue
            UserDefaults.standard.setValue(Request.RequestLoadingType.sport.rawValue, forKey: "typeRequest")
        })]
        
        let secondDivider = UIMenu(title: "Request",image: UIImage(systemName: "list.bullet"),options: .singleSelection,children: requestActions)
        
        //Доделать полный лист локализаций новостей
//        let countries = ["ar","de","en","es","fr","it","nl","no","pt","ru","sv","zh"]
//        let fullNameCountries = ["Argentina","Germany","Great Britain","Spain","France","Italy","Netherlands","Norway","Portugal","Russia","Sweden","Chech Republic"]
        
        let localeActions = [UIAction(title: "Everywhere", handler: { [unowned self] _ in
            self.localeRequest = String(Locale.preferredLanguages.first!.prefix(2))
            UserDefaults.standard.setValue(Locale.preferredLanguages.first!.prefix(2), forKey: "localeRequest")
        }),
                             UIAction(title: "Russian", handler: { [unowned self] _ in
            self.localeRequest = "ru"
            UserDefaults.standard.setValue("ru", forKey: "localeRequest")
        })]
        let thirdDivider = UIMenu(title: "Country Resources",image: UIImage(systemName: "character.bubble.fill"),options: .displayInline,children: localeActions)
        let items = [divider,secondDivider,thirdDivider]
        return UIMenu(title: "Filter news",children: items)
    }
    
    func reloadTableView(models: [Articles]) {
        dataSourceClass = FFNewsTableViewDataSource(with: models)
        delegateClass = FFNewsTableViewDelegate(with: self,model: models)
        tableView.dataSource = dataSourceClass
        tableView.delegate = delegateClass
        tableView.tableFooterView = loadDataButton
        tableView.reloadData()
    }
    
    func loadingExactType(type: String,filter: String,locale: String){
        model = []
        viewModel!.requestData(type: type,filter: filter)
        viewModel.typeRequest = type
        viewModel.sortRequest = filter
        viewModel.localeRequest = locale
        typeRequest = type
    }
}
/// отвечает за нажатие строки пользователем и возвращает индекс
extension FFNewsPageViewController: FFNewsTableViewCellDelegate {
    
    func selectedCell(indexPath: IndexPath,selectedCase: TableViewDelegateSignal?) {
        switch selectedCase {
            
        case .addToFavourite:
            print("Add to favourite")
        case .copyLink:
            UIPasteboard.general.string = model[indexPath.row].url
        case .none:
            print("Selected cell at \(indexPath.row)")
        case .some(.openImage):
            print("Open image view")
        case .some(.openLink):
            guard  let url = URL(string: model[indexPath.row].url) else { return }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
        
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
        }
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




