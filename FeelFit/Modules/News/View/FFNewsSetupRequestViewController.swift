//
//  FFNewsSetupRequestViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 10.10.2023.
//

import UIKit
import SnapKit

class FFNewsSetupRequestViewController: UIViewController, SetupViewController {
    
    
    var viewModel: FFNewsSettingViewModel?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "requestTable")
        return table
    }()
    
    private let confirmButton: UIButton = {
       let button = UIButton()
        button.configuration = .tinted()
        button.configuration?.title = "Save settings"
        button.configuration?.image = UIImage(systemName: "gear")
        button.configuration?.imagePlacement = .top
        button.configuration?.imagePadding = 2
        button.configuration?.baseBackgroundColor = FFResources.Colors.tabBarBackgroundColor
        button.configuration?.baseForegroundColor = FFResources.Colors.activeColor
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupTableView()
        setupConstraints()
    }
    
    
    func setupView() {
        viewModel = FFNewsSettingViewModel()
        
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.backgroundColor = .clear
    }
    
    func setupNavigationController() {
        title = "Setup request"
    }
}

extension FFNewsSetupRequestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

extension FFNewsSetupRequestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestTable", for: indexPath)
        cell.textLabel?.text = "Cell text label"
        return cell
    }
}

extension FFNewsSetupRequestViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(60)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}

extension FFNewsSetupRequestViewController {
    func callUIMenu() -> UIMenu {
        let filterActions = [
            UIAction(title: "Relevance") { _ in
//                self.filterRequest = Request.RequestSortType.relevancy.rawValue
                UserDefaults.standard.setValue(Request.RequestSortType.relevancy.rawValue, forKey: "filterRequest")
            },
            UIAction(title: "Popularity") { [unowned self] _ in
                
//                self.filterRequest = Request.RequestSortType.popularity.rawValue
                UserDefaults.standard.setValue(Request.RequestSortType.popularity.rawValue, forKey: "filterRequest")
            },
            UIAction(title: "Published Date") { [unowned self] _ in
//                self.filterRequest = Request.RequestSortType.publishedAt.rawValue
                UserDefaults.standard.setValue(Request.RequestSortType.publishedAt.rawValue, forKey: "filterRequest")
            },
        ]
        let divider = UIMenu(title: "Filter",image: UIImage(systemName: "line.3.horizontal.decrease.circle"),options: .singleSelection,children: filterActions)
        
        let requestActions = [ UIAction(title: "Health", handler: { [unowned self] _ in
//            self.typeRequest = Request.RequestLoadingType.health.rawValue
            UserDefaults.standard.setValue(Request.RequestLoadingType.health.rawValue, forKey: "typeRequest")
        }),
                               UIAction(title: "Fitness", handler: { [unowned self] _ in
//            self.typeRequest = Request.RequestLoadingType.fitness.rawValue
            UserDefaults.standard.setValue(Request.RequestLoadingType.fitness.rawValue, forKey: "typeRequest")
        }),
                               UIAction(title: "Gym", handler: { [unowned self] _ in
//            self.typeRequest = Request.RequestLoadingType.gym.rawValue
            UserDefaults.standard.setValue(Request.RequestLoadingType.gym.rawValue, forKey: "typeRequest")
        }),
                               UIAction(title: "Training", handler: { [unowned self] _ in
//            self.typeRequest = Request.RequestLoadingType.training.rawValue
            UserDefaults.standard.setValue(Request.RequestLoadingType.training.rawValue, forKey: "typeRequest")
        }),
                               UIAction(title: "Sport", handler: { [unowned self] _ in
//            self.typeRequest = Request.RequestLoadingType.sport.rawValue
            UserDefaults.standard.setValue(Request.RequestLoadingType.sport.rawValue, forKey: "typeRequest")
        })]
        
        let secondDivider = UIMenu(title: "Request",image: UIImage(systemName: "list.bullet"),options: .singleSelection,children: requestActions)
        
        //Доделать полный лист локализаций новостей
        //        let countries = ["ar","de","en","es","fr","it","nl","no","pt","ru","sv","zh"]
        //        let fullNameCountries = ["Argentina","Germany","Great Britain","Spain","France","Italy","Netherlands","Norway","Portugal","Russia","Sweden","Check Republic"]
        
        let localeActions = [UIAction(title: "Everywhere", handler: { [unowned self] _ in
//            self.localeRequest = String(Locale.preferredLanguages.first!.prefix(2))
            UserDefaults.standard.setValue(Locale.preferredLanguages.first!.prefix(2), forKey: "localeRequest")
        }),
                            UIAction(title: "Russian", handler: { [unowned self] _ in
//            self.localeRequest = "ru"
            UserDefaults.standard.setValue("ru", forKey: "localeRequest")
        })]
        let thirdDivider = UIMenu(title: "Country Resources",image: UIImage(systemName: "character.bubble.fill"),options: .displayInline,children: localeActions)
        let items = [divider,secondDivider,thirdDivider]
        return UIMenu(title: "Filter news",children: items)
    }
}

#Preview {
    FFNewsSetupRequestViewController()
}
