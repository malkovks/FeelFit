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

///NewsPageViewController which display table view with inheriting all data
class FFNewsPageViewController: UIViewController,SetupViewController, Coordinating {
    ///Наработки с Coordinator
    var coordinator: Coordinator?
    
    var viewModel: FFNewsPageViewModel!
//    private var delegateClass: FFNewsTableViewDelegate?
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
    
    private var refreshControll: UIRefreshControl = {
       let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Grab to refresh")
        refresh.tintColor = FFResources.Colors.activeColor
        return refresh
    }()
    
    //MARK: - View loading
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupView()
        setupNavigationController()
        setupSpinner()
        setupNewsPageViewModel()
        setupTableView()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){ [unowned self] in
            self.viewModel!.requestData(type: self.typeRequest, filter: self.filterRequest)
        }
    }
    //MARK: - Targets
    @objc private func didTapOpenFavourite(){
        coordinator?.eventOccuredNewsModule(event: .openFavourite, model: nil)
    }
    
    @objc private func didTapLoadMore(){
        let value = UserDefaults.standard.value(forKey: "pageNumberAPI") as! Int
        let pageNumber = value + 1
        UserDefaults.standard.setValue(pageNumber, forKey: "pageNumberAPI")
        viewModel!.requestData(pageNumber: pageNumber,type: typeRequest, filter: filterRequest)
    }
    
    @objc private func didTapRefreshData(){
        loadingExactType(type: typeRequest,filter: filterRequest,locale: localeRequest)
    }
    
    @objc private func didTapSetupRequest(){
        coordinator?.eventOccuredNewsModule(event: .openNewsSettings, model: nil)
    }
    
    //MARK: - Setup methods
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
        UserDefaults.standard.setValue(1, forKey: "pageNumberAPI")
    }
    
    func setupTableView(){
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.refreshControl = refreshControll
        refreshControll.addTarget(self, action: #selector(didTapRefreshData), for: .valueChanged)
    }
    
    func setupNewsPageViewModel(){
        viewModel = FFNewsPageViewModel(localModel: model,viewController: self)
        viewModel.delegate = self
        dataSourceClass = FFNewsTableViewDataSource(with: model)
        tableView.dataSource = dataSourceClass
        tableView.delegate = self
    }
    
    func setupSpinner() {
        view.addSubview(spinner)
        spinner.center = view.center
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.maximumContentSizeCategory = .small
        title = "News"
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: nil, imageName: "gear", action: #selector(didTapSetupRequest), menu: nil)
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: nil, imageName: "heart.fill", action: #selector(didTapOpenFavourite), menu: nil)
    }
    
    private func showFullSizeImage(url: String){
        let vc = FFNewsImageView()
        vc.isOpened = { opened in
            if !opened {
                self.view.alpha = 1.0
            }
        }
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                vc.imageView.image = image
            }
        }.resume()
        self.view.addSubview(vc)
        vc.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalToSuperview().dividedBy(1.5)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 0.8
            vc.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
    func reloadTableView(models: [Articles]) {
        dataSourceClass = FFNewsTableViewDataSource(with: models)
        tableView.dataSource = dataSourceClass
        tableView.delegate = self
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
    
//    func shareNews(model: Articles){
//        let newsTitle = model.title
//        guard let newsURL = URL(string: model.url) else { return }
//        let shareItems: [AnyObject] = [newsURL as AnyObject, newsTitle as AnyObject]
//        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        activityViewController.excludedActivityTypes = [.markupAsPDF,.assignToContact,.sharePlay]
//        self.present(activityViewController, animated: true)
//    }
    
}
extension FFNewsPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.delegate = self
        coordinator?.detailVC(model: model[indexPath.row])
//        viewModel.didSelectRow(at: indexPath, caseSetting: .rowSelected,model: model)
//        coordinator?.eventOccuredNewsModule(event: .tableViewDidSelect, model: self.model[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        viewModel.delegate = self
        return viewModel.contextMenuConfiguration(at: indexPath, point: point,model: model)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(view: view)
    }
    
}

///view model delegate
extension FFNewsPageViewController: FFNewsPageDelegate {
    func willLoadData() {
        spinner.startAnimating()
        refreshControll.beginRefreshing()
    }
    //доделать запрос чтобы он не добавлял по 20 новых запросов одинаково, удалял старые и добавлял новые
    func didLoadData(model: [Articles]?,error: Error?) {
        guard error == nil else {
            alertError(title: "Error!", message: error?.localizedDescription, style: .alert, cancelTitle: "OK")
            spinner.stopAnimating()
            refreshControll.endRefreshing()
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
            self.refreshControll.endRefreshing()
            viewModel = FFNewsPageViewModel(localModel: uniqueItems)
        }
    }
    
    func selectedCell(indexPath: IndexPath, model: Articles, selectedCase: NewsTableViewSelectedConfiguration?) {
//        ДОБАВЛЕНО ВО VIEWMODEL
        switch selectedCase {
        case .shareNews :
//            shareNews(model: model)
            print("Share news")
        case .addToFavourite:
//            FFNewsStoreManager.shared.saveNewsModel(model: model, status: true)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .copyLink:
            UIPasteboard.general.string = model.url
        case .rowSelected:
            let vc = FFNewsPageDetailViewController(model: model)
            navigationController?.pushViewController(vc, animated: true)
        case .some(.openImage):
            showFullSizeImage(url: model.urlToImage ?? "")
        case .some(.openLink):
            guard  let url = URL(string: model.url) else { return }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        case .none:
            break
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
    //MARK: - НЕ используется(позже удалить)
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
//        let fullNameCountries = ["Argentina","Germany","Great Britain","Spain","France","Italy","Netherlands","Norway","Portugal","Russia","Sweden","Check Republic"]
        
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
}






