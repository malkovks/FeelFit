//
//  FFProfileViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import RealmSwift

class FFProfileViewController: UIViewController, SetupViewController {
    
    private let progressiveView: UIProgressView = {
        let progresView = UIProgressView(frame: .zero)
        progresView.isHidden = true
        progresView.progressViewStyle = .bar
        progresView.progressTintColor = FFResources.Colors.activeColor
        progresView.backgroundColor = FFResources.Colors.lightBackgroundColor
        progresView.layer.cornerRadius = 8
        progresView.layer.masksToBounds = true
        progresView.progress = 0.0
        return progresView
    }()
    
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
    
    func requestLoadingData(){
        let title = "Do you want to download all data?"
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Download", style: .default, handler: { [weak self] _ in
            self?.downloadMusclesExercises()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func downloadMusclesExercises(){
        let muscles = muscleDictionary
        var count = muscles.count
        var loadedCount = 0
        var failureLoadedCount = 0
        
        progressiveView.isHidden = false
        
        for key in muscles.keys {
            FFGetExercisesDataBase.shared.getMuscleDatabase(muscle: key) { [unowned self] result in
                switch result {
                case .success(_):
                    loadedCount += 1
                    let progress = Float(loadedCount) / Float(count)
                    self.progressiveView.setProgress(progress, animated: true)
                case .failure(_):
                    failureLoadedCount += 1
                    count -= 1
                }
            }
        }
        viewAlertController(text: "\(loadedCount) of \(count+failureLoadedCount) Loaded", startDuration: 0.5, timer: 4, controllerView: self.view)
        if (count+failureLoadedCount) == muscleDictionary.count {
            progressiveView.isHidden = true
        }
    }
}

extension FFProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "profileCell")
        let imageView = UIImageView(image: UIImage(systemName: "arrow.up.right.square"))
        imageView.tintColor = FFResources.Colors.activeColor
        cell.accessoryView = imageView
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Default all data to nil"
        case 1:
            cell.textLabel?.text = "Upload all data for muscle groups"
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
            alertControllerActionConfirm(title: "Warning", message: "Drop all data from database?", confirmActionTitle: "Delete all", secondTitleAction: "Don't delete", style: .actionSheet) {
                self.deleteRealmModel()
            } secondAction: {
                print("Second action")
            }
        } else if indexPath.row == 1 {
            requestLoadingData()
        }
    }
}

extension FFProfileViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(progressiveView)
        progressiveView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.011)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
}
