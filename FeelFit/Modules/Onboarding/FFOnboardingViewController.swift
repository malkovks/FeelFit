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
        FFSendUserNotifications.shared.requestForAccessToLocalNotification { [weak self] result in
            switch result {
            case .success(_):
                self?.setupButtonConfirm(isAccessed: true)
            case .failure(_):
                self?.setupButtonConfirm(isAccessed: false)
            }
        }
    }

    
    @objc private func didTapAskHealthRequest(_ sender: UIButton){
        FFHealthDataAccess.shared.requestAccessToCharactersData { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.global().async {
                    FFHealthDataAccess.shared.requestForAccessToHealth { result in
                        switch result {
                        case .success(_):
                            self?.setupButtonConfirm(isAccessed: true)
                        case .failure(_):
                            self?.setupButtonConfirm(isAccessed: false)
                            return
                        }
                    }
                }
            case .failure(_):
                return
            }
        }
        
        
    }
    
    @objc private func didTapAskMediaRequest(_ sender: UIButton){
        let media = FFMediaDataAccess.shared
        media.requestPhotoLibraryAccess { [weak self] success in
            if success {
                media.requestAccessForCamera { status in
                    if !status {
                        self?.setupButtonConfirm(isAccessed: false)
                    } else {
                        self?.setupButtonConfirm(isAccessed: true)
                    }
                }
            } else {
                self?.setupButtonConfirm(isAccessed: false)
            }
        }
    }
    
    private func setupButtonConfirm(isAccessed: Bool){
        DispatchQueue.main.async { [weak self] in
            self?.setAccessStatusButton.configuration?.title = isAccessed ? "Access confirmed": "Access denied"
            self?.setAccessStatusButton.configuration?.subtitle = isAccessed ? nil : "For turning on go to System settings"
            self?.setAccessStatusButton.isEnabled = false
        }
    }
}





extension FFOnboardingViewController: SetupViewController {
    
    func setupView(){
        setupConstraints()
        setupNavigationController()
        setupViewModel()
    }
    
    func setupButtonConfiguration(selected type: OnboardingTypeStatus) {
        switch type {
        case .notification:
            configureSelectedType(action: #selector(didTapAskNotificationRequest), buttonTitle: "Give Access to Notification", accentColor: .systemIndigo)
        case .health:
            configureSelectedType(action: #selector(didTapAskHealthRequest), buttonTitle: "Give Access to Health", accentColor: .systemRed)
        case .cameraAndLibrary:
            configureSelectedType(action: #selector(didTapAskMediaRequest), buttonTitle: "Access to Camera and Media", accentColor: .detailText,secondaryColor: .systemBackground)
        case .none:
            configureSelectedType(action: nil, buttonTitle: "", accentColor: .systemBlue)
        }
    }
    
    private func configureSelectedType(action: Selector? = nil,buttonTitle title: String? = nil ,accentColor: UIColor? = FFResources.Colors.activeColor, secondaryColor: UIColor? = nil){
        guard let action = action else {
            setAccessStatusButton.isHidden = true
            return }
        setAccessStatusButton.addTarget(self, action: action, for: .primaryActionTriggered)
        setAccessStatusButton.configuration?.title = title
        setAccessStatusButton.configuration?.baseBackgroundColor = accentColor
        setAccessStatusButton.configuration?.baseForegroundColor = secondaryColor
        pageImageView.tintColor = accentColor
        
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
            make.height.lessThanOrEqualToSuperview().multipliedBy(0.7)
        }
        
        view.addSubview(setAccessStatusButton)
        setAccessStatusButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalTo(44)
        }
        
        let imageViewSize = view.frame.size.width / 3.5
        
        pageImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageViewSize)
        }
    }
}

#Preview {
    return FFOnboardingViewController(imageName: "heart.square", pageTitle: "Trash title", pageSubtitle: "Use HealthKit’s clinical record support to read Fast Healthcare Interoperability Resources (FHIR) from the HealthKit store. Users can download their FHIR records from supported healthcare institutions. The system then updates the records in the background on a regular basis.", type: .health)
}
