//
//  FFNewsSetupRequestViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 10.10.2023.
//

import UIKit
import SnapKit

class Section {
    let title: String
    var isOpened: Bool = false
    
    init(title: String, isOpened: Bool = false) {
        self.title = title
        self.isOpened = isOpened
    }
}



class FFNewsSetupRequestViewController: UIViewController, SetupViewController {


    let rows = [["Current","English"],["Gym","Fitness","Athletic","Running","Crossfit","Health"],["By Popular","By Published Date","By Relevancy"]]
    
    var viewModel: FFNewsSettingViewModel?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "requestTable")
        return table
    }()
    
    private var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [
            Section(title: "Localization"),
            Section(title: "Request Type"),
            Section(title: "Sort Type")
        ]
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
    }
    
    func setupNavigationController() {
        title = "Setup request"
    }
}

extension FFNewsSetupRequestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .automatic)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 200
        }
    }
}

extension FFNewsSetupRequestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestTable", for: indexPath)
        
        if indexPath.row == 0 {
            for subview in cell.subviews {
                if subview is UIPickerView {
                    subview.removeFromSuperview()
                    cell.accessoryView = nil
                }
            }
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = sections[indexPath.section].title
            return cell
        } else {
            cell.accessoryType = .none
            let button = UIButton()
            button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            button.tintColor = .black
            
            let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 200))
            pickerView.delegate = self
            pickerView.dataSource = self

            pickerView.tag = indexPath.section
            
            cell.accessoryView = button as UIView
            cell.addSubview(pickerView)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpened {
            return 2
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
}

extension FFNewsSetupRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return rows[0].count
        } else if pickerView.tag == 1 {
            return rows[1].count
        } else {
            return rows[2].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.contentMode = .scaleAspectFit
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        label.numberOfLines = 1
        if pickerView.tag == 0 {
            label.text =  rows[0][row]
        } else if pickerView.tag == 1 {
            label.text =  rows[1][row]
        } else {
            label.text =  rows[2][row]
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel?.didSelectRow(pickerView, didSelectRow: row, inComponent: component, rows: rows)
    }
    
    
}

extension FFNewsSetupRequestViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
//
//#Preview {
//    FFNewsSetupRequestViewController()
//}
