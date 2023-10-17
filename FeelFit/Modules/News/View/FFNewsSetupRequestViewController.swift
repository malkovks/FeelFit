//
//  FFNewsSetupRequestViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 10.10.2023.
//

import UIKit

class FFNewsSetupRequestViewController: UIViewController {
    var viewModel: FFNewsSettingViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel = FFNewsSettingViewModel()
        view.backgroundColor = FFResources.Colors.secondaryColor
        title = "Setup request"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapNextView))
    }
    

    @objc private func didTapNextView(){
        
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
