//
//  FFProfileViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import RealmSwift

class FFProfileViewController: UIViewController, SetupViewController {
    
    
    private var tableView: UITableView!
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.darkPurple
    }
    
    func setupNavigationController() {
        title = "Settings"
    }
    
    func setupViewModel() {
        
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.layer.cornerRadius = 12
        tableView.layer.masksToBounds = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "profileCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
    }
    
    func deleteRealmModel(){
        let data = realm.objects(FFExerciseModelRealm.self)
        try! realm.write({
            realm.delete(data)
        })
    }
}

extension FFProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "profileCell")
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Default all data to nil"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
}

extension FFProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            alertControllerActionConfirm(title: "Warning", message: "Drop all data from database?", confirmActionTitle: "Drop it", style: .actionSheet) {
                self.deleteRealmModel()
            } secondAction: {
                print("Second action")
            }
        }
    }
}

extension FFProfileViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
