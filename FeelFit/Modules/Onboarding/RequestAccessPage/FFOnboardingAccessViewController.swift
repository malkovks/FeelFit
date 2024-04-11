//
//  FFOnboardingViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 26.02.2024.
//

import UIKit

class FFOnboardingAccessViewController: UIViewController {
    
    var viewModel: FFOnboardingAccessViewModel!
    
    
    private let pageTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.headerFont(size: 24, for: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .justified
        label.contentMode = .scaleAspectFill
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let pageSubtitle: UILabel = {
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
    
    private let pageImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        return stackView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    private let successStatusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.textLabelFont(size: 32, for: .largeTitle, weight: .medium, width: .expanded)
        label.numberOfLines = 1
        label.textColor = .customBlack
        label.backgroundColor = .clear
        label.text = "Success"
        label.isHidden = true
        return label
    }()

    private var notificationButton = UIButton(type: .custom)
    private var healthButton = UIButton(type: .custom)
    private var userHealthButton = UIButton(type: .custom)
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
        setupView()
    }
    //MARK: - Actions
    func changeButtonsHiddens(){
        self.successStatusLabel.isHidden = false
        self.notificationButton.isHidden = true
        self.userHealthButton.isHidden = true
        self.healthButton.isHidden = true
        self.mediaButton.isHidden = true
        self.buttonsStackView.alignment = .center
        self.buttonsStackView.distribution = .equalCentering
        self.view.layoutIfNeeded()
    }
}


//MARK: - Setup methods
extension FFOnboardingAccessViewController: SetupViewController {
    
    func setupView(){
        view.backgroundColor = .secondarySystemBackground
        setupNavigationController()
        setupViewModel()
        configureAccessStatusButton()
        setupConstraints()
    }
    
    func configureAccessStatusButton(){
        let notificationAction = UIAction { [unowned self] _ in
            viewModel.requestAccessToNotificationsServices(notificationButton)
        }
        
        notificationButton = CustomConfigurationButton(primaryAction: notificationAction,buttonTag: 0, configurationTitle: "Access to Notification")
        
        let healthAction = UIAction { [unowned self] _ in
            viewModel.requestAccessToUserHealthDataServices(healthButton)
        }
        
        healthButton = CustomConfigurationButton(primaryAction: healthAction,buttonTag: 1, configurationTitle: "Access to Health")
        
        let userHealthAction = UIAction { [unowned self] _ in
            viewModel.requestAccessToUserMediaServices(userHealthButton)
        }
        
        userHealthButton = CustomConfigurationButton(primaryAction: userHealthAction,buttonTag: 2, configurationTitle: "Access to User's Health")
        
        let mediaAction = UIAction { [unowned self] _ in
            viewModel.requestAccessToUserMediaServices(mediaButton)
        }
        
        mediaButton = CustomConfigurationButton(primaryAction: mediaAction,buttonTag: 3, configurationTitle: "Access to Media and Camera")
    }
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        viewModel = FFOnboardingAccessViewModel(viewController: self)
        viewModel.delegate = self
    }
}


extension FFOnboardingAccessViewController: FFOnboardingAccessDelegate {
    func didGetAccessToAllServices() {
        changeButtonsHiddens()
    }
    
    
}

private extension FFOnboardingAccessViewController {
    func setupConstraints(){
        let buttons = [notificationButton, healthButton, userHealthButton, mediaButton]
        buttons.forEach { button in
            buttonsStackView.addArrangedSubview(button)
        }
        buttonsStackView.addArrangedSubview(successStatusLabel)
        
        let subviews = [pageImageView, pageTitleLabel, pageSubtitle,buttonsStackView]
        subviews.forEach { subview in
            stackView.addArrangedSubview(subview)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.lessThanOrEqualToSuperview().multipliedBy(0.8)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.size.width/1.5)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        
        
        let imageViewSize = view.frame.size.width / 3.5
        
        pageImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageViewSize)
        }
    }
}

#Preview {
    return FFOnboardingAccessViewController(imageName: "lock.square", pageTitle: "Access to Sensitive Information", pageSubtitle: "This page displays the services that this application uses. Data from these services is intended for the correct and more detailed operation of the application, and this data will be protected and will not be accessible to anyone except you. If you want to change access to any service, you can always do this in the system Settings application.")
}


