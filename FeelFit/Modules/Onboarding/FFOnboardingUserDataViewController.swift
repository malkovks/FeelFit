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
    
    private let downloadDataButton = CustomConfigurationButton(configurationTitle: "Download From Health",baseBackgroundColor: .systemBackground)
    private let saveDataButton = CustomConfigurationButton(configurationTitle: "Save Data",baseBackgroundColor: .systemBackground)

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
                        dict[key] = data.dateOfBirth?.convertComponentsToDateString() ?? "Not Set"
                    case "Gender":
                        dict[key] = data.userGender ?? "Not Set"
                    case "Blood Type":
                        dict[key] = data.bloodType ?? "Not Set"
                    case "Skin Type(Fitzpatrick Type)":
                        dict[key] = data.fitzpatrickSkinType ?? "Not Set"
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
            didTapOpenWelcomeView()
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
    
    @objc private func didTapOpenWelcomeView(){
        UserDefaults.standard.setValue(true, forKey: "isOnboardingOpenedFirst")
        let name = userDataDictionary[0]["Name"]
        let vc = FFWelcomeViewController(welcomeLabelText: name)
        vc.modalPresentationStyle = .fullScreen
        UIView.transition(with: view, duration: 1, options: .transitionFlipFromTop, animations: {
            self.present(vc, animated: true)
        }, completion: nil)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return view.frame.size.height / 5
        } else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frameRect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: view.frame.size.height/4-10)
        let customView = UserImageTableViewHeaderView(frame: frameRect)
        customView.configureCustomHeaderView(userImage: nil,isLabelHidden: true)
        return customView
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
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().multipliedBy(0.75)
        }
        
        view.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(5)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
        }
    }
}

#Preview {
    let nav = FFNavigationController(rootViewController: FFOnboardingUserDataViewController())
    nav.modalPresentationStyle = .fullScreen
    return nav
}
