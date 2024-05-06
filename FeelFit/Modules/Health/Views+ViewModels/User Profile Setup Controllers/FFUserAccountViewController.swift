//
//  FFUserAccountViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 28.04.2024.
//

import UIKit
import PhotosUI

class FFUserAccountViewController: UIViewController, ActionsWithUserImageView {
    
    private var userData: FFUserHealthMainData = .init(fullName: "Name example", account: "example@mail.com")
    
    var cameraPickerController: UIImagePickerController!
    var pickerViewController: PHPickerViewController!
    
    var userImageView: UIImageView = {
        let image = UIImage(systemName: "person.circle")!
        let scaledImage = image.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
        let imageView = UIImageView(image: scaledImage )
        imageView.tintColor = .main
        imageView.setupShadowLayer()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    var userFullNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Name & Second Name"
        label.font = UIFont.headerFont(size: 24)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        return label
    }()
    
    var userAccountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("example@mail.ru", for: .normal)
        button.setImage(UIImage(systemName: "arrow.backward.square"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .systemRed
        button.setTitleColor(.customBlack, for: .normal)
        button.titleLabel?.font = UIFont.headerFont(size: 20, for: .extraLargeTitle)
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .secondarySystemBackground
        return scrollView
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = FFResources.Colors.activeColor
        return indicator
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.tintColor = .customBlack
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Targets
    @objc private func openImageViewAlert(_ gesture: UITapGestureRecognizer){
        didTapOpenImagePicker(cameraPickerController, pickerViewController, animated: true, gesture)
    }
    
    @objc private func openDetailImage(_ gesture: UILongPressGestureRecognizer){
        didTapLongPressOnImage(gesture)
    }
    
    @objc private func didGrabScrollView(){
        reloadUserImageView()
    }
    
    @objc private func changeUserName(){
        let alertController = UIAlertController(title: "", message: "Enter your name and second name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter name"
            textField.autocapitalizationType = .words
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter second Name"
            textField.autocapitalizationType = .words
        }
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            let text1 = alertController.textFields?[0].text ?? "Name"
            let text2 = alertController.textFields?[1].text ?? "Second Name"
            self.userFullNameLabel.text = text1.removeSpaces() + " " + text2.removeSpaces()
            FFUserMainDataManager().saveUserName(name: text1, secondName: text2)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    @objc private func changeUserAccount(){
        defaultAlertController(title: "Warning", message: "Do you want to leave account?",actionTitle: "Leave",buttonStyle: .destructive) { [unowned self] in
            FFAuthenticationManager.shared.didExitFromAccount()
            let vc = FFOnboardingAuthenticationViewController(type: .authenticationOnlyDisplay)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}

extension FFUserAccountViewController: SetupViewController {
    func setupView() {
        title = "User account"
        view.backgroundColor = .clear
        loadUserData()
        
        setupUserImageView()
        setupUserNameLabel()
        setupNavigationController()
        setupViewModel()
        setupScrollView()
        setupUserAccountButton()

        setupPickerViewController()
        setupCameraPickerController()
        
        setupConstraints()
    }
    
    func setupUserImageView(){
        userImageView.image = userImage
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openImageViewAlert))
        userImageView.addGestureRecognizer(tapGesture)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(openDetailImage))
        userImageView.addGestureRecognizer(longPressGesture)
    }
    
    func setupUserNameLabel(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeUserName))
        userFullNameLabel.addGestureRecognizer(tapGesture)
    }
    
    func setupUserAccountButton(){
        userAccountButton.addTarget(self, action: #selector(changeUserAccount), for: .primaryActionTriggered)
    }
    
    func loadUserData(){
        guard let data = FFUserMainDataManager().loadUserMainData() else { return }
        userData = data
        DispatchQueue.main.async { [weak self] in
            self?.userFullNameLabel.text = data.fullName
            self?.userAccountButton.setTitle(data.account, for: .normal)
        }
    }
    
    func setupScrollView(){
        scrollView.refreshControl = refreshControl
        scrollView.refreshControl?.addTarget(self, action: #selector(didGrabScrollView), for: .primaryActionTriggered)
    }
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        
    }
    
    func reloadUserImageView(){
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [ unowned self ] in
            loadUserData()
            userImageView.image = userImage
            refreshControl.endRefreshing()
            indicatorView.stopAnimating()
            userImageView.isHidden = false
            userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        }
    }
    
}

extension FFUserAccountViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        userImageView.isHidden = true
        indicatorView.startAnimating()
        handlerSelectedImage(results)
        didGrabScrollView()
    }
}

extension FFUserAccountViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImageView.isHidden = true
        indicatorView.startAnimating()
        handlerCapturedImage(info)
        didGrabScrollView()
    }
}

extension FFUserAccountViewController: HandlerUserProfileImageProtocol {
    
}

extension FFUserAccountViewController {
    func setupConstraints(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(view.frame.size.height/5)
        }
        
        scrollView.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(view.frame.size.height/5)
        }
        
        userImageView.layoutIfNeeded()
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        userImageView.layer.masksToBounds = true
        
        scrollView.addSubview(userFullNameLabel)
        userFullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }
        
        scrollView.addSubview(userAccountButton)
        userAccountButton.snp.makeConstraints { make in
            make.top.equalTo(userFullNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(55)
        }
        
        scrollView.snp.makeConstraints { make in
            make.bottom.equalTo(userAccountButton.snp.bottom).offset(10)
        }
    }
}

#Preview {
    let vc = FFUserAccountViewController()
    let navVC = FFNavigationController(rootViewController: vc)
    navVC.isNavigationBarHidden = false
    navVC.modalPresentationStyle = .pageSheet
    return navVC
}
