//
//  FFOnboardingUserDataViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.03.2024.
//

import UIKit

class FFOnboardingUserDataViewController: UIViewController {
    
    private let tableViewText: [[String]] = [["Name","Second Name"],["Birthday","Gender","Blood Type","Skin Type(Fitzpatrick Type)"],["Stoller chair"]]
    
    private var userData: UserCharactersData? = UserCharactersData(
        userGender: "Male",
        dateOfBirth: nil,
        wheelChairUse: "Not set",
        bloodType: "Not set",
        fitzpatrickSkinType: "Not set")
    
    private var userDataDictionary: [[String: String]] = [
        ["Name":"Kostia","Second Name": "Malkov"],
        ["Birthday":"21.10.1995","Gender":"Male","Blood Type":"A+","Skin Type(Fitzpatrick Type)":"Not Set"],
        ["Stoller chair":"Not Set"]
    ]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,style: .insetGrouped)
        tableView.register(FFSubtitleTableViewCell.self, forCellReuseIdentifier: FFSubtitleTableViewCell.identifier)
        tableView.setupAppearanceShadow()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let downloadDataButton = CustomConfigurationButton(configurationTitle: "Download From Health")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func didTapLoadHealthData(){
        var dict = userDataDictionary[1]
        
        
        defaultAlertController(title: nil, message: "Do you want to download medical data from Health?", actionTitle: "Download", style: .alert) {
            FFHealthDataLoading.shared.loadingCharactersData { [unowned self] userDataString in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                for (key,_) in dict {
                    switch key{
                    case "Birthday":
                        dict[key] = userDataString?.dateOfBirth?.convertComponentsToDateString() ?? "Not Set"
                    case "Gender":
                        dict[key] = userDataString?.userGender ?? "Not Set"
                    case "Blood Type":
                        dict[key] = userDataString?.bloodType ?? "Not Set"
                    case "Skin Type(Fitzpatrick Type)":
                        dict[key] = userDataString?.fitzpatrickSkinType ?? "Not Set"
                    default:
                        dict[key] = "Not Set"
                        break
                    }
                }
                self.userDataDictionary[1] = dict
            }
        }
    }
}

extension FFOnboardingUserDataViewController: SetupViewController {
    func setupView() {
        view.backgroundColor = .secondarySystemGroupedBackground
        setupTableView()
        setupButtons()
        setupNavigationController()
        setupViewModel()
        setupConstraints()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupButtons(){
        downloadDataButton.addTarget(self, action: #selector(didTapLoadHealthData), for: .primaryActionTriggered)
    }
    
    func setupNavigationController() { }
    
    func setupViewModel() { }
}

extension FFOnboardingUserDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return userDataDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataDictionary[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFSubtitleTableViewCell.identifier, for: indexPath) as! FFSubtitleTableViewCell
        cell.configureView(userDictionary: userDataDictionary, indexPath)
        return cell
    }
}

extension FFOnboardingUserDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension FFOnboardingUserDataViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().multipliedBy(0.7)
        }
        
        view.addSubview(downloadDataButton)
        downloadDataButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(55)
        }
    }
}

#Preview {
    let nav = UINavigationController(rootViewController: FFOnboardingUserDataViewController())
    nav.modalPresentationStyle = .fullScreen
    return nav
}
