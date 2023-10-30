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
import SwiftUI

///NewsPageViewController which display table view with inheriting all data
class FFNewsPageViewController: UIViewController,SetupViewController {
    
    var viewModel: FFNewsPageViewModel!
    private var dataSourceClass: FFNewsTableViewDataSource!
    
    private var typeRequest = UserDefaults.standard.string(forKey: "typeRequest") ?? "fitness"
    private var sortRequest = UserDefaults.standard.string(forKey: "sortRequest") ?? "publishedAt"
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
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){ [unowned self] in
            self.viewModel!.requestData(type: self.typeRequest, filter: self.sortRequest,locale: self.localeRequest)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        typeRequest = UserDefaults.standard.string(forKey: "typeRequest") ?? "fitness"
        sortRequest = UserDefaults.standard.string(forKey: "sortRequest") ?? "publishedAt"
        localeRequest = UserDefaults.standard.string(forKey: "localeRequest") ?? "en"
    }
    //MARK: - Targets
    @objc private func didTapOpenFavourite(){
        let vc = FFNewsFavouriteViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapLoadMore(){
        let value = UserDefaults.standard.value(forKey: "pageNumberAPI") as! Int
        let pageNumber = value + 1
        UserDefaults.standard.setValue(pageNumber, forKey: "pageNumberAPI")
        viewModel!.requestData(pageNumber: pageNumber,type: typeRequest, filter: sortRequest,locale: localeRequest)
    }
    
    @objc private func didTapRefreshData(){
        model = []
        viewModel.refreshData(typeRequest: typeRequest, filterRequest: sortRequest, localeRequest: localeRequest)
    }
    
    @objc private func didTapSetupRequest(){
        let vc = FFNewsSetupRequestViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Setup methods
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
        UserDefaults.standard.setValue(1, forKey: "pageNumberAPI")
        loadDataButton.addTarget(self, action: #selector(didTapLoadMore), for: .touchUpInside)
    }
    
    func setupTableView(){
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.refreshControl = refreshControll
        refreshControll.addTarget(self, action: #selector(didTapRefreshData), for: .valueChanged)
    }
    
    func setupNewsPageViewModel(){
        viewModel = FFNewsPageViewModel()
        viewModel.delegate = self
        dataSourceClass = FFNewsTableViewDataSource(with: model,viewController: self)
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

    func reloadTableView(models: [Articles]) {
        dataSourceClass = FFNewsTableViewDataSource(with: models,viewController: self)
        tableView.dataSource = dataSourceClass
        tableView.delegate = self
        tableView.tableFooterView = loadDataButton
        tableView.reloadData()
    }
}
extension FFNewsPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = model[indexPath.row]
        viewModel.delegate = self
        viewModel.didSelectRow(at: indexPath, caseSetting: .rowSelected,model: model)
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
        }
    }
    
    func selectedCell(indexPath: IndexPath, model: Articles, selectedCase: NewsTableViewSelectedConfiguration?,image: UIImage?) {
        switch selectedCase {
        case .shareNews :
            viewModel.shareNews(view: self, model: model)
        case .addToFavourite:
            tableView.reloadData()
        case .copyLink:
            UIPasteboard.general.string = model.url
        case .rowSelected:
            let vc = FFNewsPageDetailViewController(model: model)
            navigationController?.pushViewController(vc, animated: true)
        case .some(.openImage):
            viewModel.openDetailViewController(view: self, image: image, url: model.urlToImage)
        case .some(.openLink):
            viewModel.openLinkSafariViewController(view: self, url: model.url)
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
}
//#Preview {
//    let vc = FFNewsPageViewController()
//    return vc
//}






