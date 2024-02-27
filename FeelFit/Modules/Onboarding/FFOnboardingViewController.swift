//
//  FFOnboardingViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 26.02.2024.
//

import UIKit

enum OnboardingTypeStatus: String {
    case notification = "Access to Notifications"
    case health = "Access to Health"
    case cameraAndLibrary = "Access to Media"
    case none
}

class FFOnboardingViewController: UIViewController {
    
    var pageTitleLabel = UILabel()
    var pageSubtitle = UILabel()
    var pageImageView = UIImageView()
    
    
    var setAccessStatusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.configuration = .filled()
        button.configuration?.title = "Give access"
        
        button.configuration?.baseForegroundColor = FFResources.Colors.textColor
        button.configuration?.baseBackgroundColor = FFResources.Colors.activeColor
        return button
    }()
    
    var displayedType: OnboardingTypeStatus
    
    init(imageName: String, pageTitle: String,pageSubtitle: String, type: OnboardingTypeStatus) {
        let config = UIImage.SymbolConfiguration(pointSize: 120, weight: .regular, scale: .medium)
        self.pageImageView.image = UIImage(systemName: imageName)!.withConfiguration(config)
        self.pageTitleLabel.text = pageTitle
        self.pageSubtitle.text = pageSubtitle
        self.displayedType = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupView()
        setupButtonConfiguration(selected: displayedType)
    }
    
    @objc private func didTapAskNotificationRequest(_ sender: UIButton){
        FFSendUserNotifications.shared.requestForAccessToLocalNotification()
    }
    
    @objc private func didTapAskBackgroundTaskRequest(_ sender: UIButton){
//        FFBackgroundTasksAccess.shared.requestBackgroundTaskPermission(identifierForTask: <#T##String#>, completion: <#T##(Bool) -> ()##(Bool) -> ()##(_ success: Bool) -> ()#>)
    }
    
    @objc private func didTapAskHealthRequest(_ sender: UIButton){
        FFHealthDataAccess.shared.requestAccessToCharactersData()
        FFHealthDataAccess.shared.requestForAccessToHealth()
    }
    
    @objc private func didTapAskMediaRequest(_ sender: UIButton){
        let media = FFMediaDataAccess.shared
        media.requestPhotoLibraryAccess { success in
            if success {
                media.requestAccessForCamera { status in
                    
                }
            }
        }
    }
    
}



extension FFOnboardingViewController: SetupViewController {
    
    func setupView(){
        setupUserInterface()
        setupConstraints()
        setupNavigationController()
        setupViewModel()
    }
    
    func setupButtonConfiguration(selected type: OnboardingTypeStatus) {
        switch type {
        case .notification:
            setAccessStatusButton.addTarget(self, action: #selector(didTapAskNotificationRequest), for: .primaryActionTriggered)
            setAccessStatusButton.configuration?.title = "Access to Notification"
        case .health:
            setAccessStatusButton.addTarget(self, action: #selector(didTapAskHealthRequest), for: .primaryActionTriggered)
            setAccessStatusButton.configuration?.title = "Access to Health"
        case .cameraAndLibrary:
            setAccessStatusButton.addTarget(self, action: #selector(didTapAskMediaRequest), for: .primaryActionTriggered)
            setAccessStatusButton.configuration?.title = "Access to Camera and Media"
        case .none:
            setAccessStatusButton.isHidden = true
        }
    }
    
    func setupUserInterface(){
        pageTitleLabel.font = UIFont.headerFont(size: 32)
        pageTitleLabel.textAlignment = .justified
        pageTitleLabel.contentMode = .center
        pageTitleLabel.numberOfLines = 1
        
        pageSubtitle.font = UIFont.textLabelFont(size: 16, weight: .thin, width: .condensed)
        pageSubtitle.numberOfLines = 0
        pageSubtitle.textColor = .detailText
        pageSubtitle.contentMode = .center
        pageSubtitle.textAlignment = .justified
        
        pageImageView.contentMode = .scaleAspectFit
        pageImageView.tintColor = FFResources.Colors.activeColor
    }
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        
    }
}

private extension FFOnboardingViewController {
    func setupConstraints(){
        let stackView = UIStackView(arrangedSubviews: [pageImageView, pageTitleLabel, pageSubtitle])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        view.addSubview(setAccessStatusButton)
        setAccessStatusButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalTo(44)
        }
        
        pageImageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
}

#Preview {
    return FFOnboardingViewController(imageName: "trash.fill", pageTitle: "Trash title", pageSubtitle: "Use HealthKit’s clinical record support to read Fast Healthcare Interoperability Resources (FHIR) from the HealthKit store. Users can download their FHIR records from supported healthcare institutions. The system then updates the records in the background on a regular basis.", type: .health)
}
