    //
//  FFHealthUserProfileViewController.swift
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
class FFHealthUserProfileViewController: UIViewController, SetupViewController, HandlerUserProfileImageProtocol {
    
    
    private var viewModel: FFHealthUserViewModel!
    private let realm = try! Realm()
    
    private let headerTextSections = [
        "",
        "Functions",
        "Сonfidentiality",
        ""
    ]
    
    
    private let textLabelRows = [
        ["Health information"
         ,"Medical Card"],
        ["Health Checklist",
         "Notification"],
        ["Application and services",
         "Scientific Research",
         "Devices"],
        ["Export Medical Data"]
    ]
    
    var userMainData: FFUserHealthMainData?

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
    
    
    /// Function open details about user's health
    private func openUserHealthData(){
        let vc = FFHealthUserInformationViewController()
        vc.userImage = managedUserImage
        navigationController?.pushViewController(vc, animated: true)
    }

}

    //MARK: Set up methods
extension FFHealthUserProfileViewController {
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
        guard let data = FFUserHealthDataStoreManager.shared.mainUserData() else {
            return
        }
        
        userMainData = data
    }
    
    func setupNavigationController() {
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Done", imageName: "", action: #selector(didTapDismiss), menu: nil)
        FFNavigationController().navigationBar.backgroundColor = .secondarySystemBackground
    }
    

    func setupViewModel() {
        viewModel = FFHealthUserViewModel(viewController: self)
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

extension FFHealthUserProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        handlerCapturedImage(info, tableView: tableView)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension FFHealthUserProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        handlerSelectedImage(results, tableView: tableView)
    }
}

//MARK: - TableView Data Source
extension FFHealthUserProfileViewController: UITableViewDataSource {
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
        return cell
    }
}

extension FFHealthUserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0 :
            openUserHealthData()
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
            let fullName = "Full name"
            customView.configureCustomHeaderView(userImage: managedUserImage,isLabelHidden: false, labelText: fullName)
            customView.configureImageTarget(selector: #selector(didTapOpenMediaPicker), target: self)
            customView.configureLongGestureImageTarget(target: self, selector: #selector(didTapOpenUserImage))
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

extension FFHealthUserProfileViewController {
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
    let navVC = FFNavigationController(rootViewController: FFHealthUserProfileViewController())
    return navVC
}

