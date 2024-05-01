    //
//  FFUserProfileViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 25.01.2024.
//

import UIKit
import Photos
import PhotosUI
import AVFoundation
import RealmSwift
import TipKit

///Class display main information about user, his basic statistics and some terms about health access and etc
class FFUserProfileViewController: UIViewController, SetupViewController, HandlerUserProfileImageProtocol {
    
    
    private var viewModel: FFUserProfileViewModel!
    private let realm = try! Realm()
    
    private let headerTextSections = [
        "",
        "Functions",
        "Сonfidentiality",
        ""
    ]
    
    
    private let textLabelRows = [
        ["User Profile"
         ,"Medical Card"],
        ["Clean cache data",
         "Clean storage data",
         "Access to Services"],
        ["Application and services",
         "Scientific Research",
         "Devices"],
        ["Exit from account"]
    ]
    
    var userMainData = FFUserHealthMainData(fullName: "No name exist", account: "No account")
    var fullUserData = FFUserHealthDataModelRealm()
    var isUserLoggedIn = FFAuthenticationManager.shared.isUserEnteredInAccount()

    var cameraPickerController: UIImagePickerController!
    
    var pickerViewController: PHPickerViewController!
    
    var button = CustomConfigurationButton(configurationTitle: "Info",configurationImage: UIImage(systemName: "trash"),baseBackgroundColor: .systemRed)
    
    private var tableView: UITableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    //MARK: - Target methods
    @objc private func didTapDismiss(){
        self.dismiss(animated: true)
    }
    
    ///method for displaying actions with users image
    @objc private func didTapOpenMediaPicker(_ gesture: UITapGestureRecognizer){
        
        didTapOpenImagePicker(tableView, cameraPickerController, pickerViewController, animated: true, gesture)
    }

    ///Method for opening user image with long press gesture
    @objc private func didTapOpenUserImage(_ sender: UILongPressGestureRecognizer){
        didTapLongPressOnImage(sender)
    }
    
    @objc private func didTapChangeUserName(_ gesture: UITapGestureRecognizer){
        presentTextFieldAlertController(placeholder: "Enter full name", keyboardType: .default, text: userMainData.fullName, alertTitle: "Enter your full name", message: nil) { [weak self] text in
            self?.userMainData.fullName = text
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    
    /// Function open details about user's health
    private func pushUserHealthData(){
        let vc = FFHealthUserInformationViewController()
        vc.userImage = managedUserImage
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushUserData(){
        let vc = FFUserAccountViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func clearUserCache(){
        defaultAlertController(title: "Clear cache", message: "Do you want to delete all cached information?", actionTitle: "Delete", style: .alert, buttonStyle: .destructive) {
            print("Delete")
        }
    }
    
    func clearStoreData(){
        guard let textSize = collectRealmStorageWeight() else { return }//подсчет веса данных всех моделей реалма на устройстве
        defaultAlertController(title: "Clear store data", message: "Storage memory fille on \(textSize) MB.\nDo you want to delete storage and delete all data?", actionTitle: "Delete", style: .alert, buttonStyle: .destructive) {
            print("Delete")
        }
    }
    
    func checkAccessStatus(){
        let vc = FFAccessToServicesViewController()
        let nav = FFNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        nav.isNavigationBarHidden = false
        nav.sheetPresentationController?.detents = [.medium()]
        nav.sheetPresentationController?.prefersGrabberVisible = true
        present(nav, animated: true)
    }

    func exitFromAccount(){
        
        let id = fullUserData.userAccountLogin
        let alert = UIAlertController(title: "Exit from account", message: "Your ID is \(id) and you want to leave this account.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { [weak self ] _ in
            FFAuthenticationManager.shared.didExitFromAccount()
            let vc = FFOnboardingAuthenticationViewController()
            vc.saveEditedAccountButton.isHidden = false
            vc.isDataCreated = { status in
                FFUserHealthDataStoreManager.shared.loadUserDataDictionary()
            }
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
            
        }))
        present(alert, animated: true)
    }

}

    //MARK: Set up methods
extension FFUserProfileViewController {
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        feedbackGenerator.prepare()
        FFHealthDataAccess.shared.requestAccessToCharactersData()
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupCameraPickerController()
        setupPickerViewController()
        loadUserData()
        setupConstraints()
    }
    
    func loadUserData(){
        if let data = FFUserHealthDataStoreManager.shared.mainUserData(){
            userMainData = data
        } else {
            let value = FFUserHealthMainData(fullName: "Full name", account: "")
            userMainData = value
        }
        
        guard let fullData = FFUserHealthDataStoreManager.shared.loadUserDataModel() else { return }
        fullUserData = fullData
    }
    
    func setupNavigationController() {
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Done", imageName: "", action: #selector(didTapDismiss), menu: nil)
        FFNavigationController().navigationBar.backgroundColor = .secondarySystemBackground
    }
    

    func setupViewModel() {
        viewModel = FFUserProfileViewModel(viewController: self)
    }
    
    private func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FFUserProfileTableViewCell.self, forCellReuseIdentifier: FFUserProfileTableViewCell.identifier)
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .clear
        tableView.bounces = true
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 44
        tableView.setupAppearanceShadow()
    }
}

extension FFUserProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        handlerCapturedImage(info, tableView: tableView)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension FFUserProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        handlerSelectedImage(results, tableView: tableView)
    }
}

//MARK: - TableView Data Source
extension FFUserProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        headerTextSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        textLabelRows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFUserProfileTableViewCell.identifier, for: indexPath) as! FFUserProfileTableViewCell
        cell.configureCell(indexPath: indexPath, textArray: textLabelRows)
        return cell
    }
}

extension FFUserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case [0,0]:
            pushUserData()
        case [0,1]:
            pushUserHealthData()
        case [1,0]:
            clearUserCache()
        case [1,1]:
            clearStoreData()
        case [1,2]:
            checkAccessStatus()
        case [2,0]:
            print("Информация о приложении и сервисах")
        case [2,1]:
            print("Исследовательская работа. Опциональная строка")
        case [2,2]:
            print("Девайсы. опционально")
        case [3,0]:
            exitFromAccount()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 44
        } else {
            return view.frame.size.height / 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let frameRect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: view.frame.size.height/4-10)
            let customView = UserImageTableViewHeaderView(frame: frameRect)
            customView.configureCustomHeaderView(userImage: managedUserImage,isLabelHidden: false, labelText: fullUserData.userAccountLogin)
            customView.configureImageTarget(selector: #selector(didTapOpenMediaPicker), target: self)
            customView.configureLongGestureImageTarget(target: self, selector: #selector(didTapOpenUserImage))
            customView.configureChangeUserName(target: self, selector: #selector(didTapChangeUserName))
            return customView
        } else {
            let label = UILabel(frame: CGRect(x: 5, y: 5, width: tableView.frame.width-10, height: 34))
            label.font = UIFont.textLabelFont(size: 24)
            label.text = headerTextSections[section]
            label.textAlignment = .left
            let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
            customView.addSubview(label)
            return customView
        }
    }
}

extension FFUserProfileViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}

#Preview {
    let vc = FFNavigationController(rootViewController: FFUserProfileViewController())
    return vc
}
