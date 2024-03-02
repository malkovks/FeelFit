//
//  FFOnboardingViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 26.02.2024.
//

import UIKit

class FFOnboardingViewController: UIViewController {
    
    var pageTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.headerFont(size: 24, for: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .justified
        label.contentMode = .center
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    var pageSubtitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.textLabelFont(size: 16,for: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textColor = .detailText
        label.contentMode = .center
        label.textAlignment = .justified
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    var pageImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private var healthBackgroundButton = UIButton(type: .custom)
    private var notificationButton = UIButton(type: .custom)
    private var healthButton = UIButton(type: .custom)
    private var mediaButton = UIButton(type: .custom)
    
    
    init(imageName: String, pageTitle: String,pageSubtitle: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 120, weight: .regular, scale: .medium)
        self.pageImageView.image = UIImage(systemName: imageName)!.withConfiguration(config)
        self.pageTitleLabel.text = pageTitle
        self.pageSubtitle.text = pageSubtitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupView()
//        setupButtonConfiguration(selected: displayedType)
    }
    
    private func didTapAskNotificationRequest(_ button: UIButton){
        FFSendUserNotifications.shared.requestForAccessToLocalNotification { [weak self] result in
            switch result {
            case .success(let success):
                self?.setupButtonConfirm(isAccessed: success,button)
            case .failure(let error):
                self?.setupButtonConfirm(isAccessed: false,button, error: error)
            }
        }
    }

    private func didTapAskHealthBackgroundRequest(_ button: UIButton){
        FFHealthDataAccess.shared.requestAccessToBackgroundMode { result in
            switch result {
            case .success(let success):
                self.setupButtonConfirm(isAccessed: success,button)
            case .failure(let error):
                self.setupButtonConfirm(isAccessed: false,button, error: error)
            }
        }
    }
    
    func didTapAskHealthRequest(_ button: UIButton){
        FFHealthDataAccess.shared.requestAccessToCharactersData { [weak self] result in
            switch result {
            case .success(_):
                FFHealthDataAccess.shared.requestForAccessToHealth { result in
                    switch result {
                    case .success(let success):
                        self?.setupButtonConfirm(isAccessed: success,button)
                    case .failure(let error):
                        self?.setupButtonConfirm(isAccessed: false,button,error: error)
                        return
                    }
                }
            case .failure(_):
                return
            }
        }
    }
    
    private func didTapAskMediaRequest(_ button: UIButton){
        let media = FFMediaDataAccess.shared
        media.requestPhotoLibraryAccess { [weak self] success in
            if success {
                media.requestAccessForCamera { status in
                    if !status {
                        self?.setupButtonConfirm(isAccessed: false,button)
                    } else {
                        self?.setupButtonConfirm(isAccessed: true,button)
                    }
                }
            } else {
                self?.setupButtonConfirm(isAccessed: false,button)
            }
        }
    }
    
    private func setupButtonConfirm(isAccessed: Bool,_ button: UIButton,error: Error? = nil){
        DispatchQueue.main.async {
            button.configuration?.title = isAccessed ? "Access confirmed": "Access denied"
            button.configuration?.subtitle = isAccessed ? nil : "For turning on go to System settings"
            button.isEnabled = false
        }
        if let error = error {
            DispatchQueue.main.async { [unowned self] in
                self.viewAlertController(text: error.localizedDescription, startDuration: 0.5, timer: 4, controllerView: self.view)
            }
        }
    }
}





extension FFOnboardingViewController: SetupViewController {
    
    func setupView(){
        
        setupNavigationController()
        setupViewModel()
        configureAccessStatusButton()
        setupConstraints()
    }
    
    func configureAccessStatusButton(){
        let healthBackgroundAction = UIAction { [unowned self] _ in
            didTapAskHealthBackgroundRequest(healthBackgroundButton)
        }
        
        healthBackgroundButton = CustomConfigurationButton(primaryAction: healthBackgroundAction, configurationTitle: "Access to Health Background", baseBackgroundColor: .systemIndigo, baseForegroundColor: .systemBackground)
        
        let healthAction = UIAction { [unowned self] _ in
            didTapAskHealthRequest(healthButton)
        }
        
        healthButton = CustomConfigurationButton(primaryAction: healthAction, configurationTitle: "Access to Health", baseBackgroundColor: .systemRed, baseForegroundColor: .systemBackground)
        
        let notificationAction = UIAction { [unowned self] _ in
            didTapAskNotificationRequest(notificationButton)
        }
        
        notificationButton = CustomConfigurationButton(primaryAction: notificationAction, configurationTitle: "Access to Notification", baseBackgroundColor: .systemBlue, baseForegroundColor: .systemBackground)
        
        let mediaAction = UIAction { [unowned self] _ in
            didTapAskMediaRequest(mediaButton)
        }
        
        mediaButton = CustomConfigurationButton(primaryAction: mediaAction, configurationTitle: "Access to Media and Camera", baseBackgroundColor: .darkGray, baseForegroundColor: .systemBackground)
    }
    
//    func setupButtonConfiguration(selected type: OnboardingTypeStatus) {
//        switch type {
//        case .notification:
//            configureSelectedType(action: #selector(didTapAskNotificationRequest), buttonTitle: "Give Access to Notification", accentColor: .systemIndigo)
//        case .health:
//            configureSelectedType(action: nil, buttonTitle: "Give Access to Health", accentColor: .systemRed)
//        case .cameraAndLibrary:
//            configureSelectedType(action: #selector(didTapAskMediaRequest), buttonTitle: "Access to Camera and Media", accentColor: .detailText,secondaryColor: .systemBackground)
//        case .none:
//            configureSelectedType(action: nil, buttonTitle: "", accentColor: .systemBlue)
//        case .some:
//            configureSelectedType(action: #selector(didTapAskHealthBackgroundRequest), buttonTitle: "Access to Background Health Data", accentColor: .systemIndigo, secondaryColor: .darkPurple)
//        }
//    }
    
//    private func configureSelectedType(action: Selector? = nil,buttonTitle title: String? = nil ,accentColor: UIColor? = FFResources.Colors.activeColor, secondaryColor: UIColor? = nil){
//        guard let action = action else {
//            setAccessStatusButton.isHidden = true
//            return }
//        setAccessStatusButton.addTarget(self, action: action, for: .primaryActionTriggered)
//        setAccessStatusButton.configuration?.title = title
//        setAccessStatusButton.configuration?.baseBackgroundColor = accentColor
//        setAccessStatusButton.configuration?.baseForegroundColor = secondaryColor
//        pageImageView.tintColor = accentColor
//    }
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        
    }
}

private extension FFOnboardingViewController {
    func setupConstraints(){
        let buttonStackView = UIStackView(arrangedSubviews: [mediaButton,
                                                             healthButton, healthBackgroundButton, notificationButton])
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillProportionally
        buttonStackView.spacing = 2
        
        let stackView = UIStackView(arrangedSubviews: [pageImageView, pageTitleLabel, pageSubtitle,buttonStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.lessThanOrEqualToSuperview().multipliedBy(0.8)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.size.width/1.5)
        }
        
        
        
        let imageViewSize = view.frame.size.width / 3.5
        
        pageImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageViewSize)
        }
    }
}

#Preview {
    return FFOnboardingViewController(imageName: "lock.square", pageTitle: "Trash title", pageSubtitle: "This page displays the services that this application uses. Data from these services is intended for the correct and more detailed operation of the application, and this data will be protected and will not be accessible to anyone except you. If you want to change access to any service, you can always do this in the system Settings application.")
}


