//
//  FFOnboardingUserDataViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.03.2024.
//

import UIKit
import PhotosUI
import TipKit

class FFOnboardingUserDataViewController: UIViewController, HandlerUserProfileImageProtocol {
    
    private let calendar = Calendar.current
    
    var cameraPickerController: UIImagePickerController!
    var pickerViewController: PHPickerViewController!
    var viewModel: FFOnboardingUserDataViewModel!
    private weak var tipView: TipUIView?
    
    private var userDataDictionary: [[String: String]] = [
        ["Name":"Enter Name",
         "Second Name": "Enter Second Name"],
        ["Birthday":"Not Set",
         "Gender":"Not Set",
         "Blood Type":"Not Set",
         "Skin Type(Fitzpatrick Type)":"Not Set",
         "Stoller chair":"Not Set"],
        ["Load data from Health": ""],
        ["Save data":""]
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInlineInfo(titleText: "User Information", messageText: "You can fill out the table manually or download data from the Health application; it will be available if you previously filled it out and gave access to the application. Filling out this information is optional, but recommended.", popoverImage: "heart", arrowEdge: .bottom) { tipView in
            tipView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.9)
            }
            self.tipView = tipView
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tipView = tipView {
            tipView.removeFromSuperview()
            self.tipView = nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let tipView = tipView {
            tipView.removeFromSuperview()
            self.tipView = nil
        }
    }
    
    
    
}

extension FFOnboardingUserDataViewController {
    @objc private func didTapOpenImage(_ sender: UITapGestureRecognizer){
        didTapOpenImagePicker(tableView, cameraPickerController, pickerViewController, animated: true, sender)
    }
    
    @objc private func didTapLongPress(_ longGesture: UILongPressGestureRecognizer){
        didTapLongPressOnImage(longGesture)
    }
    
    //MARK: - Actions methods
    ///Обработан
    @objc private func didTapLoadHealthData(){
        viewModel.loadHealthData(userData: userDataDictionary)
    }
    
    ///Обработан
    @objc func didTapOpenPickerView(_ indexPath: IndexPath){
        viewModel.openPickerView(indexPath)
    }
    ///Обработан
    @objc private func didTapSaveUserData(){
        viewModel.didTapSaveUserData { result in
            switch result{
            case .success(_):
                setupViewAfterSaving(error: nil)
            case .failure(let error):
                setupViewAfterSaving(error: error)
            }
        }
    }
    
    @objc private func didTapOpenWelcomeView(){
        viewModel.didTapOpenWelcomeView()
    }
}


//MARK: - Setup methods
extension FFOnboardingUserDataViewController: SetupViewController {
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupViewModel()
        setupTableView()
        setupButtons()
        setupNavigationController()
        setupCameraPickerController()
        setupPickerViewController()
        setupConstraints()
    }
    
    func setupTableViewSelection(isDataLoaded: Bool, row: Int = 0, section: Int = 2){
        let indexPath = IndexPath(row: row, section: section)
//        let cell = tableView.cellForRow(at: indexPath) as! FFCenteredTitleTableViewCell
        if isDataLoaded{
            
            DispatchQueue.main.async {
                let cell = self.tableView.cellForRow(at: indexPath) as! FFCenteredTitleTableViewCell
                self.tableView.reloadData()
                cell.setupDisplayText(text: "Loaded",backgroundColor: .lightGray, isUserInteractionEnabled:  false)
//                cell.setupDisplayText(text: "Loaded",backgroundColor: .lightGray, isUserInteractionEnabled:  false)
            }
        } else {
            
            DispatchQueue.main.async {
                let cell = self.tableView.cellForRow(at: indexPath) as! FFCenteredTitleTableViewCell
                self.tableView.reloadData()
                cell.setupDisplayText(text: "Failed. Try again",backgroundColor: .systemMint, isUserInteractionEnabled:  true)
//                cell.setupDisplayText(text: "Loaded",backgroundColor: .lightGray, isUserInteractionEnabled:  false)
            }
        }
    }
    
    func setupViewAfterSaving(error: (any Error)?){
        if let error = error {
            let textError = error.localizedDescription
            saveDataButton.configuration?.title = "Error"
            saveDataButton.configuration?.baseBackgroundColor = .systemRed
            downloadDataButton.isHidden = false
            viewAlertController(text: textError, controllerView: self.view)
        } else {
            saveDataButton.configuration?.title = "Saved"
            saveDataButton.configuration?.baseBackgroundColor = .mintGreen
            saveDataButton.isEnabled = false
            downloadDataButton.isHidden = true
            didTapOpenWelcomeView()
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = true
        tableView.flashScrollIndicators()
        tableView.register(FFCenteredTitleTableViewCell.self, forCellReuseIdentifier: FFCenteredTitleTableViewCell.identifier)
        tableView.register(FFSubtitleTableViewCell.self, forCellReuseIdentifier: FFSubtitleTableViewCell.identifier)
    }
    
    private func setupButtons(){
        downloadDataButton.addTarget(self, action: #selector(didTapLoadHealthData), for: .primaryActionTriggered)
        saveDataButton.addTarget(self, action: #selector(didTapSaveUserData), for: .primaryActionTriggered)
    }
    
    func setupNavigationController() { }
    
    func setupViewModel() { 
        viewModel = FFOnboardingUserDataViewModel(viewController: self, userDataDictionary: userDataDictionary, tableView: tableView)
        viewModel.delegate = self
    }
    
    
    
    private func returnSelectedValueFromDictionary(_ index: Int) -> String {
        let dictionary = userDataDictionary[1]
        let value: String = Array(dictionary.values).sorted()[index]
        return value
    }
}

///Delegate method from OnboardingUserViewModel for returning data
extension FFOnboardingUserDataViewController: FFOnboardingUserDataProtocol {
    func completionUserData(arrayDictionary: [[String : String]]?, text: String?, key: String?) {
        guard let key = key else { return }
        self.userDataDictionary[1][key] = text
    }
    
    func didTapLoadUserData(userData: [String : String]?) {
        if let data = userData {
            userDataDictionary[1] = data
            setupTableViewSelection(isDataLoaded: true)
        } else {
            setupTableViewSelection(isDataLoaded: false)
        }
    }
    
}

extension FFOnboardingUserDataViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        handlerCapturedImage(info, tableView: tableView)
        tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension FFOnboardingUserDataViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        handlerSelectedImage(results, tableView: tableView)
    }
}



//MARK: - Table View Data Source
extension FFOnboardingUserDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return userDataDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataDictionary[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0,1:
            let cell = tableView.dequeueReusableCell(withIdentifier: FFSubtitleTableViewCell.identifier, for: indexPath) as! FFSubtitleTableViewCell
            cell.configureView(userDictionary: userDataDictionary, indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: FFCenteredTitleTableViewCell.identifier, for: indexPath) as! FFCenteredTitleTableViewCell
            cell.configureCell(data: userDataDictionary, indexPath: indexPath)
            return cell
        }
    }
}

//MARK: - Table View Delegate
extension FFOnboardingUserDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.tableView(tableView, heightForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        viewModel.tableView(tableView, heightForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        viewModel.tableView(tableView, viewForHeaderInSection: section, userImage: managedUserImage, isLabelHidden: true, didTapImage: #selector(didTapOpenImage), longPress: #selector(didTapLongPress), target: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dictionary = userDataDictionary[indexPath.section]
        let key: String = Array(dictionary.keys).sorted()[indexPath.row]
        let value: String = dictionary[key] ?? ""
        
        switch indexPath.section {
        case 0:
            presentTextFieldAlertController(placeholder: "Enter value",text: value,alertTitle: "Enter User Data",message: "Write Your Name and Second Name") { [unowned self] text in
                self.viewModel.changeUserDataValue(indexPath.row, text: text)
            }
        case 1:
            didTapOpenPickerView(indexPath)
        case 2:
            didTapLoadHealthData()
        case 3:
            didTapSaveUserData()
        default:
            break
        }
    }
    

}

extension FFOnboardingUserDataViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().multipliedBy(0.75)
        }
    }
}

#Preview {
    return FFOnboardingUserDataViewController()
}
