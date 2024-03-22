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
    private let saveDataButton = CustomConfigurationButton(configurationTitle: "Save Data")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    //MARK: - Actions methods
    @objc private func didTapLoadHealthData(){
        guard var dict = userDataDictionary.last else { return }
        
        
        defaultAlertController(title: nil, message: "Do you want to download medical data from Health?", actionTitle: "Download", style: .alert) {
            FFHealthDataLoading.shared.loadingCharactersData { [unowned self] userDataString in
                guard let data = userDataString else { return }
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
    
    @objc func didTapOpenPickerView(_ indexPath: IndexPath){
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
    
    @objc private func didTapSaveUserData(){
        let manager = FFUserHealthDataStoreManager.shared
        let resultSavingData = manager.saveNewUserData(userDataDictionary)
        switch resultSavingData {
            
        case .success(_):
            saveDataButton.configuration?.title = "Saved"
            saveDataButton.configuration?.baseBackgroundColor = .mintGreen
            saveDataButton.isEnabled = false
            downloadDataButton.isHidden = true
        case .failure(let error):
            let textError = error.localizedDescription
            saveDataButton.configuration?.title = "Error"
            saveDataButton.configuration?.baseBackgroundColor = .systemRed
            downloadDataButton.isHidden = false
            viewAlertController(text: textError, controllerView: self.view)
        }
    }
    
    private func changeUserDataValue(_ index: Int, section: Int = 1,text value: String?){
        let indexPath = IndexPath(row: index, section: section)
        
        guard let text = value else {
            viewAlertController(text: "Value is empty", controllerView: view)
            return
        }

        let dictionary = userDataDictionary[section]
        let keys: [String] = Array(dictionary.keys).sorted()
        let keyDictionary: String = keys[index]
        userDataDictionary[section][keyDictionary] = text
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
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
        saveDataButton.addTarget(self, action: #selector(didTapSaveUserData), for: .primaryActionTriggered)
    }
    
    func setupNavigationController() { }
    
    func setupViewModel() { }
    
    
    
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
        let dictionary = userDataDictionary[indexPath.section]
        let key: String = Array(dictionary.keys).sorted()[indexPath.row]
        let value: String = dictionary[key] ?? ""
        
        switch indexPath.section {
        case 0:
            presentTextFieldAlertController(placeholder: "Enter value",text: value,alertTitle: "Enter User Data",message: "Write Your Name and Second Name") { [unowned self] text in
                self.changeUserDataValue(indexPath.row, section: indexPath.section, text: text)
            }
        case 1:
            didTapOpenPickerView(indexPath)
        default:
            break
        }
    }
}

extension FFOnboardingUserDataViewController {
    private func setupConstraints(){
        
        let horizontalStackView = UIStackView(arrangedSubviews: [downloadDataButton,saveDataButton])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.spacing = 5
        horizontalStackView.distribution = .fillEqually
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().multipliedBy(0.7)
        }
        
        view.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.bottom.equalToSuperview().multipliedBy(0.8)
        }
    }
}

extension FFOnboardingUserDataViewController {
    
    func presentTextFieldAlertController(placeholder: String? = "Enter value",
                                         text: String? = nil,
                                         alertTitle: String? = nil,
                                         message: String? = nil,
                                         completion handler: @escaping (_ text: String) -> () ){
        let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        
        
        alertController.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = text
            textField.enablesReturnKeyAutomatically = true
            textField.textColor = .customBlack
            textField.textAlignment = .left
            textField.autocapitalizationType = .words
            textField.clearButtonMode = .always
            textField.font = UIFont.textLabelFont(for: .body, weight: .light)
            textField.keyboardType = .default
            textField.returnKeyType = .go
        }
        
        let saveAction = (UIAlertAction(title: "Save", style: .default) { action in
            
            
            if let textField = alertController.textFields?.first,
               let text = textField.text,
               !text.isEmpty {
                handler(text)
            }
        })
        alertController.addAction(saveAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let titleFont = UIFont.textLabelFont(size: 20,for: .title1, weight: .semibold)
        let attributedTitle = NSAttributedString(string: alertTitle ?? "", attributes: [.font: titleFont])
        let messageFont = UIFont.textLabelFont(size: 14,for: .body,weight: .thin)
        let attributedMessage = NSAttributedString(string: message ?? "", attributes: [.font: messageFont])
        let imageSave = UIImage(systemName: "square.and.arrow.down.fill")
        
        
        saveAction.setValue(imageSave, forKey: "image")
        
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        present(alertController,animated: true)
        
    }
}

#Preview {
    let nav = FFNavigationController(rootViewController: FFOnboardingUserDataViewController())
    nav.modalPresentationStyle = .fullScreen
    return nav
}
