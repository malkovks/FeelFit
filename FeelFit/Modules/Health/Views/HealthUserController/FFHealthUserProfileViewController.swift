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
    
    private var scrollView: UIScrollView = UIScrollView(frame: .zero)
    private var userImageView: UIImageView = UIImageView(frame: .zero)
    private var userFullNameLabel: UILabel = UILabel(frame: .zero)
    private var tableView: UITableView = UITableView(frame: .zero)
    


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
//        FFHealthDataAccess.shared.requestAccessToCharactersData()
    }
    
    
    //MARK: - Target methods
    @objc private func didTapDismiss(){
        self.dismiss(animated: true)
    }
    
    ///method for displaying actions with users image
    @objc private func didTapOpenImagePicker(_ gesture: UITapGestureRecognizer){
        let alertController = UIAlertController(title: "What to do?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Open Camera", style: .default,handler: { [weak self] _ in
            self?.openCamera()
        }))
        alertController.addAction(UIAlertAction(title: "Open Library", style: .default,handler: { [weak self] _ in
            self?.didTapOpenPickerController()
        }))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteUserImage()
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    ///Method for opening user image with long press gesture
    @objc private func didTapOpenUserImage(_ sender: UILongPressGestureRecognizer){
        guard let userImage = userImageView.image else { return }
        if sender.state == .began {
            let vc = FFImageDetailsViewController(newsImage: userImage, imageURL: "")
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
//        var status = false
//        FFMediaDataAccess.shared.returnCameraAccessStatus { success in
//            <#code#>
//        }
//        returnCameraAccessStatus { success in
//            
//        }
//        returnPhotoLibraryAccessStatus { success in
//            status = success
//        }
//        handler(status)
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
    
    // Не нужен
    private func compressImageWeight(_ image: UIImage,_ size: CGFloat) {
        guard let data = image.jpegData(compressionQuality: size) else { return }
        let nsImageData = NSData(data: data)
        let imageSize: Int = nsImageData.count
        print("Image size \(Double(imageSize)/1000)")
    }
    
    private func saveUserImage(_ image: UIImage,fileName: String){
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let filesURL = getDocumentaryURL().appendingPathComponent(fileName)
        do {
            try data.write(to: filesURL)
            UserDefaults.standard.set(fileName, forKey: "userProfileFileName")
            userImageFileName = fileName
        } catch {
            fatalError("FFHealthUserProfileViewController.saveUserImage ==> Error saving to file url. Check the way to save data")
        }
    }
    
    private func loadUserImage() -> UIImage? {
        let filesURL = getDocumentaryURL().appendingPathComponent(userImageFileName)
        do {
            let imageData = try Data(contentsOf: filesURL)
            return UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func deleteUserImage() {
        let fileURL = getDocumentaryURL().appendingPathComponent(userImageFileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
            DispatchQueue.main.async {
                self.userImageView = UIImageView(image: UIImage(systemName: "person.crop.circle"))
            }
        } catch {
            print("Error deleting image " + error.localizedDescription)
        }
    }
    
    func getDocumentaryURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directory = paths.first!
        return directory
    }
    
    private func isUserImageSavedInDirectory() -> Bool {
        let fileURL = getDocumentaryURL().appendingPathComponent(userImageFileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return true
        } else {
            return false
        }
    }
    
    //MARK: Set up methods
    
    
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupUserLabel()
        setupUserImageView()
        setupScrollView()
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
        
        userImageView = UIImageView(image: userImage)
        userImageView.setupShadowLayer()
        userImageView.frame = CGRectMake(0, 0, view.frame.size.width/5, view.frame.size.width/5)
        userImageView.tintColor = FFResources.Colors.activeColor
        userImageView.isUserInteractionEnabled = true
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.layer.masksToBounds = true
        userImageView.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOpenImagePicker))
        userImageView.addGestureRecognizer(tapGesture)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapOpenUserImage))
        longPressGesture.minimumPressDuration = 0.3
        userImageView.addGestureRecognizer(longPressGesture)
        if let image = loadUserImage() {
            userImageView.image = image
        } else {
            print("FFHealthUserProfileVC.setupUserImageView error getting image from file path url ")
        }
    }
    
    
    
    private func setupUserLabel(){
        userFullNameLabel = UILabel(frame: .zero)
        userFullNameLabel.text = "Malkov Konstantin"
        userFullNameLabel.font = UIFont.headerFont(size: 24)
        userFullNameLabel.textAlignment = .center
        userFullNameLabel.numberOfLines = 1
    }
    
    private func setupScrollView(){
        scrollView = UIScrollView(frame: .zero)
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userHealthCell")
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 44
    }
}

extension FFHealthUserProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.livePhoto] as? UIImage else { print("Error getting image from camera");self.dismiss(animated: true);  return }
        DispatchQueue.main.async {
            self.userImageView.image = image
            
        }
    }
}

extension FFHealthUserProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        //Разобраться с закрытием и добавлением фото в userImageView
       convertSelectedImage(results)
    }
    
    private func convertSelectedImage(_ results: [PHPickerResult]){
        let fileName = "userImage.jpeg"
        guard let result = results.first else { return }
        let itemProvider = result.itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let image = image as? UIImage else {
                    self?.dismiss(animated: true)
                    return
                }
                
                if !self!.isUserImageSavedInDirectory() {
                    self?.deleteUserImage()
                    self?.saveUserImage(image, fileName: fileName)
                    DispatchQueue.main.async {
                        self?.userImageView.image = image
                    }
                } else {
                    self?.saveUserImage(image, fileName: fileName)
                    DispatchQueue.main.async {
                        self?.userImageView.image = image
                    }
                }
                self?.userImage = image
            }
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
        vc.userImage = userImageView.image
        navigationController?.pushViewController(vc, animated: true)
        
//        let navVC = FFNavigationController(rootViewController: vc)
//        navVC.isNavigationBarHidden = false
//        present(navVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: tableView.frame.width-10, height: 34))
        label.font = UIFont.textLabelFont(size: 24)
        label.text = headerTextSections[section]
        label.textAlignment = .left
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        customView.addSubview(label)
        return customView
    }
}

extension FFHealthUserProfileViewController {
    private func setupConstraints(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let imageSize = view.frame.size.width/5
        
        
        scrollView.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(imageSize)
        }
        
        scrollView.addSubview(userFullNameLabel)
        userFullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        scrollView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(userFullNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().multipliedBy(0.8)
            make.height.lessThanOrEqualToSuperview().multipliedBy(2)
            make.width.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width)
        }
        
    }
    
    #Preview {
        return FFHealthUserProfileViewController()
    }

}

