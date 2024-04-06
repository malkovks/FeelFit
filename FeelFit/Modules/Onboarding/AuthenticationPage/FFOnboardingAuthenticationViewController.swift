//
//  FFOnboardingAuthenticationViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.03.2024.
//

import UIKit
import TipKit

protocol FFOnboardingActionsDelegate: AnyObject {
    func didTapSkipRegistration()
}

class FFOnboardingAuthenticationViewController: UIViewController {
    
    
    weak var delegate: FFOnboardingActionsDelegate?
    private weak var tipView: TipUIView?
    
    private var isPasswordHidden: Bool = true
    private let accountManager = FFUserAccountManager.shared
    
    private let loginUserLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Login"
        label.font = UIFont.headerFont(for: .title1)
        label.textAlignment = .center
        label.contentMode = .scaleToFill
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let authStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let userEmailTextField: UITextField = {
        let leftCustomView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        let textfield = UITextField(frame: .zero)
        textfield.leftView = leftCustomView
        textfield.leftViewMode = .always
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.placeholder = "Your Email"
        textfield.clearButtonMode = .whileEditing
        textfield.textAlignment = .left
        textfield.font = UIFont.headerFont(for: .body)
        textfield.adjustsFontForContentSizeCategory = true
        textfield.textColor = FFResources.Colors.customBlack
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .asciiCapable
        textfield.returnKeyType = .continue
        textfield.textContentType = .emailAddress
        return textfield
    }()
    
    private let userPasswordTextField: UITextField = {
        let leftCustomView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        let textfield = UITextField(frame: .zero)
        textfield.leftView = leftCustomView
        textfield.leftViewMode = .always
        textfield.rightViewMode = .always
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.placeholder = "Your Password"
        textfield.clearButtonMode = .whileEditing
        textfield.textAlignment = .left
        textfield.font = UIFont.headerFont(for: .body)
        textfield.adjustsFontForContentSizeCategory = true
        textfield.textColor = FFResources.Colors.customBlack
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .asciiCapable
        textfield.isSecureTextEntry = true
        textfield.returnKeyType = .done
        textfield.passwordRules = nil
        textfield.textContentType = .oneTimeCode
        return textfield
    }()
    
    private let changePasswordSecureButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = FFResources.Colors.customBlack
        button.contentMode = .left
        return button
    }()
    
    private let logoutAccountButton = CustomConfigurationButton(configurationTitle: "Log out")
    private let createAccountButton = CustomConfigurationButton(configurationTitle: "Create Account")
    private let loginAccountButton = CustomConfigurationButton(configurationTitle: "Login")
    private let skipRegistrationButton = CustomConfigurationButton(configurationTitle: "Skip registration")
    
    private let updateOrDeleteAccountButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Delete account", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInlineInfo(titleText: "Registery", messageText: "This page is intended for user registration and for further storing unique data of this user. If you skip registration, the data will not be able to be fully saved and used in the future. Registration allows you to work regardless of connectivity.", popoverImage: "info",arrowEdge: .top) {[unowned self] tipView in
            tipView.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.authStackView.snp.bottom).offset(5)
                make.width.equalToSuperview().multipliedBy(0.9)
            }
            self.tipView = tipView
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tipView = tipView {
            tipView.removeFromSuperview()
            self.tipView = nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let tipView = view.subviews.first(where: { $0 is TipUIView }){
            tipView.removeFromSuperview()
        }
    }
    
    //MARK: - Target methods
    @objc private func didTapSkipOnboarding(){
        defaultAlertController(message: "Do you want to skip registration and entering Your anthropometric indicators. Just in case you can do it later", actionTitle: "Skip", style: .alert) { [weak self] in
            self?.dismiss(animated: true)
            self?.saveUserLoggedInStatus(isLoggedIn: false, userAccount: nil)
            self?.delegate?.didTapSkipRegistration()
        }
    }
    
    @objc private func didTapLogout(){
        defaultAlertController(message: "Do you want to log out from account?", actionTitle: "Log out", style: .alert) { [weak self] in
            self?.saveUserLoggedInStatus(isLoggedIn: false, userAccount: nil)
            self?.confirmButton(completed: false)
        }
    }
    
    //Create account
    @objc private func didTapCreateNewAccount(){
        performKeychainRequest() { [weak self] userData in
            try self?.accountManager.createNewUserAccount(userData: userData)
            self?.delegate?.didTapSkipRegistration()
        }
    }
    //Log in to account
    @objc private func didTapLogin(){
        performKeychainRequest() { [weak self] userData in
            try self?.accountManager.loginToCreatedAccount(userData: userData)
            self?.delegate?.didTapSkipRegistration()
        }
    }
    
    //Update password or delete account
    @objc private func didTapDeleteAccount(){
        defaultAlertController(title: "Warning", message: "Do you really want to delete created account?", actionTitle: "Delete",style: .actionSheet) { [weak self] in
            self?.performKeychainRequest(requestFunction: { userData in
                try self?.accountManager.deleteUserAccountData(userData: userData)
                self?.clearTextFields()
            })
        }
    }
    
    
    
    //MARK: - Action setups methods
    private func clearTextFields(){
        userEmailTextField.text = nil
        userPasswordTextField.text = nil
        confirmButton(completed: false)
    }
    
    private func checkFieldsEmptyStatus() -> CredentialUser? {
        guard let emailText = userEmailTextField.text,
              let password = userPasswordTextField.text else {
            viewAlertController(text: "Fill all fields correctly", controllerView: self.view)
            return nil
        }
        return CredentialUser(email: emailText, password: password)
    }
    
    
    private func performKeychainRequest(requestFunction: (_ userData: CredentialUser?) throws -> Void ){
        let data = checkFieldsEmptyStatus()
        do {
            try requestFunction(data)
            confirmButton(completed: true)
            saveUserLoggedInStatus(isLoggedIn: true, userAccount: data?.email)
            viewAlertController(text: "Successfully", startDuration: 0.5, timer: 4, controllerView: self.view)
        } catch let error as KeychainError {
            confirmButton(completed: false)
            saveUserLoggedInStatus(isLoggedIn: false, userAccount: nil)
            self.viewAlertController(text: error.errorDescription, startDuration: 0.5, timer: 4, controllerView: self.view)
        } catch {
            confirmButton(completed: false)
            saveUserLoggedInStatus(isLoggedIn: false, userAccount: nil)
            self.viewAlertController(text: "Fatal error", startDuration: 0.5, timer: 4, controllerView: self.view)
        }
    }
    
    private func saveUserLoggedInStatus(isLoggedIn: Bool, userAccount: String?){
        UserDefaults.standard.setValue(isLoggedIn, forKey: "userLoggedIn")
        UserDefaults.standard.setValue(userAccount, forKey: "userAccount")
    }
    
    private func confirmButton(completed: Bool){
        if completed {
            UIView.animate(withDuration: 0.2) { [unowned self] in
                loginAccountButton.alpha = 0
                createAccountButton.alpha = 0
                logoutAccountButton.alpha = 1
                updateOrDeleteAccountButton.alpha = 1
                skipRegistrationButton.alpha = 0
            } completion: { [unowned self] _ in
                skipRegistrationButton.isHidden = true
                loginAccountButton.isHidden = true
                createAccountButton.isHidden = true
                logoutAccountButton.isHidden = false
                updateOrDeleteAccountButton.isHidden = false
                view.layoutIfNeeded()
            }
        } else {
            skipRegistrationButton.configuration?.title = "Skip Registration"
            skipRegistrationButton.addTarget(self, action: #selector(didTapSkipOnboarding), for: .primaryActionTriggered)
            skipRegistrationButton.configuration?.baseBackgroundColor = .clear
            
            UIView.animate(withDuration: 0.2) { [unowned self] in
                loginAccountButton.alpha = 1
                createAccountButton.alpha = 1
                logoutAccountButton.alpha = 0
                updateOrDeleteAccountButton.alpha = 0
                skipRegistrationButton.alpha = 1
            } completion: { [unowned self] _ in
                loginAccountButton.isHidden = false
                createAccountButton.isHidden = false
                skipRegistrationButton.isHidden = false
                logoutAccountButton.isHidden = true
                updateOrDeleteAccountButton.isHidden = true
                view.layoutIfNeeded()
            }
            userEmailTextField.text = ""
            userPasswordTextField.text = ""
        }
        
    }
    
    private func changePasswordSecureAction(){
        if isPasswordHidden {
            isPasswordHidden.toggle()
            userPasswordTextField.isSecureTextEntry = false
            changePasswordSecureButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            isPasswordHidden.toggle()
            userPasswordTextField.isSecureTextEntry = true
            changePasswordSecureButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
}

extension FFOnboardingAuthenticationViewController: SetupViewController {
    
    
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupUserConfirmButton()
        setupTextFields()
        setupNavigationController()
        setupViewModel()
        setupConstraints()
        let accountLoggedIn = UserDefaults.standard.object(forKey: "userLoggedIn")
        saveUserLoggedInStatus(isLoggedIn: (accountLoggedIn != nil), userAccount: nil)
    }
    
    private func setupUserConfirmButton(){
        logoutAccountButton.isHidden = true
        logoutAccountButton.addTarget(self, action: #selector(didTapLogout), for: .primaryActionTriggered)
        createAccountButton.addTarget(self, action: #selector(didTapCreateNewAccount), for: .primaryActionTriggered)
        loginAccountButton.addTarget(self, action: #selector(didTapLogin), for: .primaryActionTriggered)
        skipRegistrationButton.addTarget(self, action: #selector(didTapSkipOnboarding), for: .primaryActionTriggered)
        updateOrDeleteAccountButton.addTarget(self, action: #selector(didTapDeleteAccount), for: .primaryActionTriggered)
    }
    
    private func setupTextFields(){
        let arrayTextFields = [userEmailTextField, userPasswordTextField]
        arrayTextFields.forEach { textField in
            textField.delegate = self
            textField.inputAccessoryView = setupToolBar(target: self)
        }
        let changePasswordSecureAction = UIAction { [weak self] _ in
            self?.changePasswordSecureAction()
        }
        changePasswordSecureButton.addAction(changePasswordSecureAction, for: .primaryActionTriggered)
        userPasswordTextField.rightView = changePasswordSecureButton
    }
    
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        
    }
}

extension FFOnboardingAuthenticationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userEmailTextField {
            userPasswordTextField.becomeFirstResponder()
            return true
        } else if textField == userPasswordTextField {
            view.endEditing(true)
            return true
        }
        
        return true
    }
}

private extension FFOnboardingAuthenticationViewController {
    func setupConstraints(){
        authStackView.addArrangedSubview(userEmailTextField)
        authStackView.addArrangedSubview(userPasswordTextField)
        authStackView.addArrangedSubview(logoutAccountButton)
        authStackView.addArrangedSubview(loginAccountButton)
        authStackView.addArrangedSubview(createAccountButton)
        authStackView.addArrangedSubview(updateOrDeleteAccountButton)
        
        view.addSubview(loginUserLabel)
        loginUserLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        view.addSubview(authStackView)
        authStackView.snp.makeConstraints { make in
            make.top.equalTo(loginUserLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.lessThanOrEqualToSuperview().multipliedBy(0.3)
        }
        
        logoutAccountButton.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        loginAccountButton.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        
        view.addSubview(skipRegistrationButton)
        skipRegistrationButton.snp.makeConstraints { make in
            let skipButtonY = view.frame.size.height*0.75
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(skipButtonY)
            
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(55)
        }
        
        
    }
}

#Preview {
    let navVC = UINavigationController(rootViewController: FFOnboardingAuthenticationViewController())
    return navVC
}
