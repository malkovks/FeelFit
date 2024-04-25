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
        ["Export Medical Data"]
    ]
    
    var userMainData: FFUserHealthMainData!

    var cameraPickerController: UIImagePickerController!
    
    var pickerViewController: PHPickerViewController!
    
    var button = CustomConfigurationButton(configurationTitle: "Info",configurationImage: UIImage(systemName: "trash"),baseBackgroundColor: .systemRed)
    
    private var tableView: UITableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //сделать секции корректными. То есть 1 секция это данные пользователя, Также добавит вход выход из аккаунта
        //вторая секция настройки кэша и памяти
        //третья это доступ к данным типа уведомлений и пр.
        //убрать модуль пользователь из tabBar
        //подумать еще что нужно доделать /добавить
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
        //показывать изображение, имя фамилию, почту аккаунта возможность выйти из аккаунта(мб сделать в таблице)
    }
    
    func clearUserCache(){
        //создать запрос у пользователя хочет ли он очистить весь кэш приложения
    }
    
    func clearStoreData(){
        //cоздать запрос хочет ли пользователь удалить весь сохраненный материал на устройство
    }
    
    func checkAccessStatus(){
        //открывает отдельный класс где показывается к каким сервисам доступ у пользователя есть, а каким нету
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userHealthCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "userHealthCell", for: indexPath)
        cell.backgroundColor = .systemBackground
        cell.textLabel?.text = textLabelRows[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension FFUserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath {
        case [0,0]:
            pushUserHealthData()
        case [0,1]:
            pushUserData()
        default:
            showInlineInfo(titleText: "Title",
                           messageText: "This cell containts some info",
                           popoverImage: "info.circle")
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
            customView.configureCustomHeaderView(userImage: managedUserImage,isLabelHidden: false, labelText: userMainData.fullName)
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
