//
//  FFOnboardingUserDataViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.03.2024.
//

import UIKit

class FFOnboardingUserDataViewController: UIViewController {
    
    private let calendar = Calendar.current
    
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
    
    //MARK: - Actions methods
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
        
    }
    
    @objc func didTapOpenPickerView(_ indexPath: IndexPath){
        view.endEditing(true)
        let index = indexPath.row
        let value: String = returnSelectedValueFromDictionary(index)
        let vc = FFPickerViewController(selectedValue: value,
                                        tableViewIndex: index,
                                        blurEffectStyle: .dark,
                                        vibrancyEffect: .none)
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


//MARK: - Setup methods
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
        tableView.allowsSelection = true
    }
    
    private func setupButtons(){
        downloadDataButton.addTarget(self, action: #selector(didTapLoadHealthData), for: .primaryActionTriggered)
    }
    
    func setupNavigationController() { }
    
    func setupViewModel() { }
    
    private func changeUserDataValue(_ index: Int,text value: String?){
        let indexPath = IndexPath(row: index, section: 1)
        
        if let text = value {
            guard let dictionary = userDataDictionary.last else { return }
            let keys: [String] = Array(dictionary.keys).sorted()
            let keyDictionary: String = keys[index]
            userDataDictionary[1][keyDictionary] = text
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func returnSelectedValueFromDictionary(_ index: Int) -> String {
        let dictionary = userDataDictionary[1]
        let value: String = Array(dictionary.values).sorted()[index]
        return value
    }
}

//Delegate method returning selected result from FFPickerViewDelegate
extension FFOnboardingUserDataViewController: FFPickerViewDelegate {
    func didReceiveSelectedDate(selectedDate: Date?, index: Int) {
        let dateComponents = selectedDate?.convertDateToDateComponents()
        let dateString = dateComponents?.convertComponentsToDateString()
        changeUserDataValue(index, text: dateString)
    }
    
    func didReceiveSelectedValue(selectedValue: String?, index: Int) {
        changeUserDataValue(index, text: selectedValue)
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
        cell.configureView(userDictionary: userDataDictionary, indexPath)
        return cell
    }
}

extension FFOnboardingUserDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            didTapOpenPickerView(indexPath)
        }
    }
}

extension FFOnboardingUserDataViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
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

extension FFOnboardingUserDataViewController {
    func presentTextFieldAlertController(placeholder: String? = "Enter value", text: String?, alertTitle: String? = nil, message: String? = nil, completion handler: @escaping (String) -> ()){
        let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
            textField.borderStyle = .roundedRect
            textField.text = text
            textField.enablesReturnKeyAutomatically = true
            textField.textColor = .customBlack
            textField.textAlignment = .left
            textField.autocapitalizationType = .words
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { alertAction in
            if let textField = alertController.textFields?.first,
               let text = textField.text {
                
            }
        }
        
    }
}

#Preview {
    let nav = FFNavigationController(rootViewController: FFOnboardingUserDataViewController())
    nav.modalPresentationStyle = .fullScreen
    return nav
}
