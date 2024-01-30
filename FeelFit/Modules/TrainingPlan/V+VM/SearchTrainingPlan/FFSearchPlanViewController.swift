//
//  FFSearchPlanViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 07.01.2024.
//

import UIKit
import RealmSwift

class FFSearchPlanViewController: UIViewController, SetupViewController {
    private let realm = try! Realm()
    private var plansData: [FFTrainingPlanRealmModel] = []
    
    var filteredPlans: [FFTrainingPlanRealmModel] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    private var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConstraints()
        setupView()
        setupNavigationController()
        setupViewModel()
        loadPlansData()
    }
    
    func setupView() {
        view.backgroundColor = .systemGroupedBackground
    }
    
    func setupNavigationController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Enter the date"
        searchController.searchBar.keyboardType = .asciiCapable
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.becomeFirstResponder()
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false 
        definesPresentationContext = true
    }
    
    func setupViewModel() {
        
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadPlansData(){
        plansData = realm.objects(FFTrainingPlanRealmModel.self).sorted(by: { $0.trainingDate > $1.trainingDate })
    }
    
    
}

extension FFSearchPlanViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentValue(searchBar.text!)
    }
    
    func filterContentValue(_ searchText: String){
        let predicate = NSPredicate(format: "trainingName CONTAINS[c] %@ OR trainingNotes CONTAINS[c] %@", searchText,searchText)
        let data = realm.objects(FFTrainingPlanRealmModel.self).filter(predicate)
        filteredPlans = Array(data)
        tableView.reloadData()
    }
}

extension FFSearchPlanViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPlans.count
        } else {
            return plansData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "searchCell")
        cell.tintColor = FFResources.Colors.activeColor
        let trainingPlan: FFTrainingPlanRealmModel
        if isFiltering {
            trainingPlan = filteredPlans[indexPath.row]
        } else {
            trainingPlan = plansData[indexPath.row]
        }
        let image = UIImageView(image: UIImage(systemName: "arrow.up.forward.app"))
        cell.accessoryView = image
        cell.textLabel?.text = DateFormatter.localizedString(from: trainingPlan.trainingDate, dateStyle: .short, timeStyle: .short)
        cell.detailTextLabel?.text = "Title: " +  trainingPlan.trainingName + ". Notes: " + trainingPlan.trainingNotes
        return cell
    }
}

extension FFSearchPlanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = isFiltering ? filteredPlans[indexPath.row] : plansData[indexPath.row]
        let vc = FFPlanDetailsViewController(data: data)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let data = isFiltering ? filteredPlans[indexPath.row] : plansData[indexPath.row]
        let vc = FFPlanDetailsViewController(data: data)
        return UIContextMenuConfiguration(identifier: nil) {
            return vc
        } actionProvider: { _ in
            let action = UIAction(title: "Open", image: UIImage(systemName: "arrow.up.forward.app")) { _ in
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let menu = UIMenu(children: [action])
            return menu
        }

    }
}

extension FFSearchPlanViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
