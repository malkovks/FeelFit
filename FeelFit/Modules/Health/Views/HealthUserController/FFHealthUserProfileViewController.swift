    //
//  FFHealthUserProfileViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 25.01.2024.
//

import UIKit
import Photos
import PhotosUI


///Class display main information about user, his basic statistics and some terms about health access and etc
class FFHealthUserProfileViewController: UIViewController, SetupViewController {
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private let userImageManager = FFUserImageManager.shared
    
    private var viewModel: FFHealthUserViewModel!
    
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
    
    private var userImage: UIImage = UIImage(systemName: "person.crop.circle")!
    private var userImageFileName = UserDefaults.standard.string(forKey: "userProfileFileName") ?? "userImage.jpeg"
    
    private var pickerConfiguration: PHPickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
    private let cameraViewController = UIImagePickerController()
    private var pickerViewController : PHPickerViewController!
    
    private var tableView: UITableView = UITableView(frame: .zero)
    
    private var managedUserImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    
    //MARK: - Target methods
    @objc private func didTapDismiss(){
        self.dismiss(animated: true)
    }
    
    ///method for displaying actions with users image
    @objc private func didTapOpenImagePicker(_ gesture: UITapGestureRecognizer){
        let fileName = userImageFileName
        let alertController = UIAlertController(title: "What to do?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Open Camera", style: .default,handler: { [weak self] _ in
            self?.feedbackGenerator.impactOccurred()
            self?.openCamera()
        }))
        alertController.addAction(UIAlertAction(title: "Open Library", style: .default,handler: { [weak self] _ in
            self?.feedbackGenerator.impactOccurred()
            self?.didTapOpenPickerController()
        }))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.feedbackGenerator.impactOccurred()
//            self?.deleteUserImage()
            strongSelf.managedUserImage = strongSelf.userImageManager.deleteUserImage(fileName)
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    ///Method for opening user image with long press gesture
    @objc private func didTapOpenUserImage(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            let vc = FFImageDetailsViewController(newsImage: managedUserImage, imageURL: "")
            self.feedbackGenerator.impactOccurred()
            present(vc, animated: true)
        } else if sender.state == .ended {
            
        }
    }
    
    private func didTapOpenPickerController(){
        checkAccessToCameraAndMedia { status in
            if status {
                setupPhotoPickerView()
                present(pickerViewController, animated: true)
            }else {
                didTapOpenPickerController()
            }
        }
    }
    
    private func checkAccessToCameraAndMedia(handler: (_ status: Bool) -> ()){
        var status = false
        FFMediaDataAccess.shared.returnCameraAccessStatus { success in
            status = success
        }
        FFMediaDataAccess.shared.returnPhotoLibraryAccessStatus { success in
            status = success
        }
        handler(status)
    }
    
    private func openCamera(){
        checkAccessToCameraAndMedia { status in
            if status {
                self.present(cameraViewController, animated: true)
            } else {
                openCamera()
            }
        }
    }
   //
//    private func saveUserImage(_ image: UIImage,fileName: String){
//        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
//        let filesURL = getDocumentaryURL().appendingPathComponent(fileName)
//        do {
//            try data.write(to: filesURL)
//            UserDefaults.standard.set(fileName, forKey: "userProfileFileName")
//            userImageFileName = fileName
//        } catch {
//            fatalError("FFHealthUserProfileViewController.saveUserImage ==> Error saving to file url. Check the way to save data")
//        }
//    }
    
//    private func loadUserImage() -> UIImage? {
//        let filesURL = getDocumentaryURL().appendingPathComponent(userImageFileName)
//        do {
//            let imageData = try Data(contentsOf: filesURL)
//            return UIImage(data: imageData)
//        } catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
    
//    private func deleteUserImage() {
//        let fileURL = getDocumentaryURL().appendingPathComponent(userImageFileName)
//        do {
//            try FileManager.default.removeItem(at: fileURL)
//            managedUserImage = UIImage(systemName: "person.crop.circle")!
//            reloadTableViewSection()
//        } catch {
//            print("Error deleting image " + error.localizedDescription)
//        }
//    }
    
//    func getDocumentaryURL() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let directory = paths.first!
//        return directory
//    }
    
//    private func isUserImageSavedInDirectory() -> Bool {
//        let fileURL = getDocumentaryURL().appendingPathComponent(userImageFileName)
//        if FileManager.default.fileExists(atPath: fileURL.path) {
//            return true
//        } else {
//            return false
//        }
//    }
    
    private func reloadTableViewSection(){
        DispatchQueue.main.async { [weak self] in
            let indexSet = IndexSet(integer: 0)
            self?.tableView.reloadSections(indexSet, with: .fade)
        }
        
    }
}

    //MARK: Set up methods
extension FFHealthUserProfileViewController {
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        feedbackGenerator.prepare()
        FFHealthDataAccess.shared.requestAccessToCharactersData()
        setupUserImageView()
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupPhotoPickerView()
        setupConstraints()
        setupCameraViewController()
    }
    
    private func setupPhotoPickerView(){
        let newFilter = PHPickerFilter.any(of: [.images,.livePhotos])
        pickerConfiguration.filter = newFilter
        pickerConfiguration.preferredAssetRepresentationMode = .current
        pickerConfiguration.selection = .ordered
        pickerConfiguration.selectionLimit = 1
        pickerConfiguration.mode = .default
        pickerViewController = PHPickerViewController(configuration: pickerConfiguration)
        pickerViewController.delegate = self
    }
    
    private func setupCameraViewController(){
        cameraViewController.delegate = self
        cameraViewController.sourceType = .camera
        cameraViewController.mediaTypes = ["public.image"]
        cameraViewController.showsCameraControls = true
        cameraViewController.cameraCaptureMode = .photo
    }
    
    func setupNavigationController() {
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Done", imageName: "", action: #selector(didTapDismiss), menu: nil)
        FFNavigationController().navigationBar.backgroundColor = .secondarySystemBackground
    }
    

    func setupViewModel() {
        viewModel = FFHealthUserViewModel(viewController: self)
    }
    
    private func setupUserImageView(){
        managedUserImage = userImageManager.loadUserImage(userImageFileName)
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
        #error("Фиксить")
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else {
            alertError(title: "Can't get image from camera. Try again!")
            self.dismiss(animated: true)
            return
        }
        self.managedUserImage = image
        reloadTableViewSection()
    }
}

extension FFHealthUserProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
       convertSelectedImage(results)
    }
    
    private func convertSelectedImage(_ results: [PHPickerResult]){
        let fileName = "userImage.jpeg"
        
        guard let result = results.first else { return }
        let itemProvider = result.itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else {
                    return
                }
                
                guard let image = image as? UIImage else {
                    self.dismiss(animated: true)
                    return
                }
                
                let saveStatus = userImageManager.isUserImageSavedInDirectory(userImageFileName)
                checkIsImageSaved(saveStatus, fileName: fileName, image: image)
            }
        }
    }
    
    private func checkIsImageSaved(_ boolean: Bool,fileName: String,image: UIImage) {
        if boolean {
            _ = userImageManager.deleteUserImage(userImageFileName)
           userImageFileName = fileName
           userImageManager.saveUserImage(image, fileName: fileName)
           managedUserImage = image
           reloadTableViewSection()
        } else {
           userImageFileName = fileName
           userImageManager.saveUserImage(image, fileName: fileName)
           managedUserImage = image
           reloadTableViewSection()
        }
    }
}

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
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension FFHealthUserProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FFHealthUserInformationViewController()
        vc.userImage = managedUserImage
        navigationController?.pushViewController(vc, animated: true)
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
            customView.configureCustomHeaderView(userImage: managedUserImage,isLabelHidden: false, labelText: "Some Name")
            customView.configureImageTarget(selector: #selector(didTapOpenImagePicker), target: self)
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
    let navVC = UINavigationController(rootViewController: FFHealthUserProfileViewController())
    return navVC
}

