//
//  FFOnboardingUserDataViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.03.2024.
//

import UIKit

class FFOnboardingUserDataViewController: UIViewController {
    
    private let calendar = Calendar.current
    
    private var userData: UserCharactersData? = UserCharactersData(
        userGender: "Male",
        dateOfBirth: nil,
        wheelChairUse: "Not set",
        bloodType: "Not set",
        fitzpatrickSkinType: "Not set")
    
    private var userDataDictionary: [[String: String]] = [
        ["Name":"Enter Name",
         "Second Name": "Enter Second Name"],
        ["Birthday":"Not Set",
         "Gender":"Not Set",
         "Blood Type":"Not Set",
         "Skin Type(Fitzpatrick Type)":"Not Set",
         "Stoller chair":"Not Set"]
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
        guard var dict = userDataDictionary.last else { return }
        
        
        defaultAlertController(title: nil, message: "Do you want to download medical data from Health?", actionTitle: "Download", style: .alert) {
            FFHealthDataLoading.shared.loadingCharactersData { [unowned self] userDataString in
                
                for (key,_) in dict {
                    switch key {
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
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc private func didEnterTextInTextField(_ textField: UITextField){
//        if let text = textField.text{
//            let index = textField.tag
//            
//        }
    }
    
    @objc func didTapOpenPickerView(_ sender: UIButton){
        let index = sender.tag
        let vc = FFPickerViewController(tableViewIndex: index, blurEffectStyle: .dark, vibrancyEffect: .none)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        nav.sheetPresentationController?.detents = [.custom(resolver: { context in
            return self.view.frame.size.height * 0.5
        })]
        nav.sheetPresentationController?.prefersGrabberVisible = true
        present(nav,animated: true)
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
        tableView.isScrollEnabled = false
    }
    
    private func setupButtons(){
        downloadDataButton.addTarget(self, action: #selector(didTapLoadHealthData), for: .primaryActionTriggered)
    }
    
    func setupNavigationController() { }
    
    func setupViewModel() { }
}

extension FFOnboardingUserDataViewController: FFPickerViewDelegate {
    func didReceiveSelectedData(selectedDate: Date?, selectedValue: String?, selectedIndex: Int) {
        let indexPath = IndexPath(row: selectedIndex, section: 1)
        let date = selectedDate
        
        if date != nil {
            let dateComponents = date?.convertDateToDateComponents()
            let dateString = dateComponents?.convertComponentsToDateString()
            changeDictionaryKeyValue(selectedIndex, text: dateString)
        } else {
            changeDictionaryKeyValue(selectedIndex, text: selectedValue)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func changeDictionaryKeyValue(_ index: Int,text value: String?){
        let text = value ?? "Not Set"
        var dictionary = userDataDictionary[1]
        let key: String = Array(dictionary.keys).sorted()[index]
        userDataDictionary[1][key] = text
    }
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
        cell.titleTextField.addTarget(self, action: #selector(didEnterTextInTextField), for: .editingDidEnd)
        cell.firstTitleLabel.textColor = .customBlack
        cell.titleTextField.tag = indexPath.row
        cell.pickerTargetButton.tag = indexPath.row
        cell.pickerTargetButton.addTarget(self, action: #selector(didTapOpenPickerView), for: .primaryActionTriggered)
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
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().multipliedBy(0.7)
        }
        
        view.addSubview(downloadDataButton)
        downloadDataButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(55)
        }
    }
}

#Preview {
    let nav = FFNavigationController(rootViewController: FFOnboardingUserDataViewController())
    nav.modalPresentationStyle = .fullScreen
    return nav
}
