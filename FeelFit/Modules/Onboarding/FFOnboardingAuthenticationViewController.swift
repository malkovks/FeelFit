//
//  FFOnboardingAuthenticationViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.03.2024.
//

import UIKit

class FFOnboardingAuthenticationViewController: UIViewController {
    
    private var isPasswordHidden: Bool = true
    private let accountManager = FFUserAccountManager.shared
    private var accountCredential: CredentialUser?
    
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
        textfield.placeholder = "Your Email"
        textfield.clearButtonMode = .whileEditing
        textfield.textAlignment = .left
        textfield.font = UIFont.headerFont(for: .body)
        textfield.adjustsFontForContentSizeCategory = true
        textfield.textColor = FFResources.Colors.customBlack
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .asciiCapable
        textfield.returnKeyType = .continue
        return textfield
    }()
    
    private let userPasswordTextField: UITextField = {
        let leftCustomView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        let textfield = UITextField(frame: .zero)
        textfield.leftView = leftCustomView
        textfield.leftViewMode = .always
        textfield.rightViewMode = .always
        textfield.autocapitalizationType = .none
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
        button.setTitle("Edit or delete account", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func didTapCreateNewAccount(){
        guard let email = userEmailTextField.text,
              let password = userPasswordTextField.text
        else {
            return
        }
        
        let data = CredentialUser(email: email, password: password)
        self.accountCredential = data
        
        performKeychainRequest(completed: true) { [weak self] userData in
            try self?.accountManager.createNewUserAccount(userData: userData)
        }
    }
    
    
    
    @objc private func didTapLogin(){
        guard let email = userEmailTextField.text,
              let password = userPasswordTextField.text
        else {
            return
        }
        
        let data = CredentialUser(email: email, password: password)
        self.accountCredential = data
        
        performKeychainRequest(completed: true) { [weak self] userData in
            try self?.accountManager.checkForCreatedUserAccount(userData: userData)
            self?.confirmButton(completed: true)
        }
    }
    
    @objc private func didTapDismissKeyboard(){
        view.endEditing(true)
    }
     
    @objc private func didTapSkipOnboarding(){
        defaultAlertController(message: "Do you want to skip registration and entering Your anthropometric indicators. Just in case you can do it later", actionTitle: "Skip", style: .alert) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    @objc private func didTapLogout(){
        defaultAlertController(message: "Do you want to log out from account?", actionTitle: "Log out", style: .alert) { [weak self] in
            self?.confirmButton(completed: false)
        }
    }
    
    @objc private func didTapUpdateOrDeleteAccount(){
        alertControllerActionConfirm(title: "Warning", message: "Do you want to update your email or password or delete account?", confirmActionTitle: "Update", secondTitleAction: "Delete", style: .alert) { [weak self] in
            self?.performKeychainRequest(completed: false, requestFunction: { userData in
                try self?.accountManager.updateUserAccountData(userData: userData)
            })
        } secondAction: { [weak self] in
            self?.performKeychainRequest(completed: false, requestFunction: { userData in
                try self?.accountManager.deleteUserAccountData(userData: userData)
            })
        }
    }
    
    private func performKeychainRequest(completed status : Bool,requestFunction: (_ userData: CredentialUser?) throws -> Void ){
        do {
            try requestFunction(accountCredential)
            confirmButton(completed: status)
            viewAlertController(text: "Successfully", startDuration: 0.5, timer: 4, controllerView: self.view)
        } catch let error as KeychainError {
            self.viewAlertController(text: error.errorDescription, startDuration: 0.5, timer: 4, controllerView: self.view)
        } catch {
            self.viewAlertController(text: "Fatal error", startDuration: 0.5, timer: 4, controllerView: self.view)
        }
    }
    
    private func confirmButton(completed: Bool){
        if completed {
            skipRegistrationButton.configuration?.title = "Continue"
            skipRegistrationButton.configuration?.baseBackgroundColor = .lightGray
            loginAccountButton.isHidden = true
            createAccountButton.isHidden = true
            logoutAccountButton.isHidden = false
            updateOrDeleteAccountButton.isHidden = false
            userEmailTextField.isEnabled = false
            userPasswordTextField.isEnabled = false
        } else {
            skipRegistrationButton.configuration?.title = "Skip Registration"
            skipRegistrationButton.configuration?.baseBackgroundColor = .clear
            loginAccountButton.isHidden = false
            createAccountButton.isHidden = false
            logoutAccountButton.isHidden = true
            updateOrDeleteAccountButton.isHidden = true
            userEmailTextField.isEnabled = true
            userPasswordTextField.isEnabled = true
            userEmailTextField.text = ""
            userPasswordTextField.text = ""
            accountCredential = nil
        }
        authStackView.layoutIfNeeded()
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
    }
    
    private func setupUserConfirmButton(){
        logoutAccountButton.isHidden = true
        logoutAccountButton.addTarget(self, action: #selector(didTapLogout), for: .primaryActionTriggered)
        createAccountButton.addTarget(self, action: #selector(didTapCreateNewAccount), for: .primaryActionTriggered)
        loginAccountButton.addTarget(self, action: #selector(didTapLogin), for: .primaryActionTriggered)
        skipRegistrationButton.addTarget(self, action: #selector(didTapSkipOnboarding), for: .primaryActionTriggered)
        updateOrDeleteAccountButton.addTarget(self, action: #selector(didTapUpdateOrDeleteAccount), for: .primaryActionTriggered)
    }
    
    private func setupTextFields(){
        let arrayTextFields = [userEmailTextField, userPasswordTextField]
        arrayTextFields.forEach { textField in
            textField.delegate = self
            textField.inputAccessoryView = setupToolBar()
        }
        let changePasswordSecureAction = UIAction { [weak self] _ in
            self?.changePasswordSecureAction()
        }
        changePasswordSecureButton.addAction(changePasswordSecureAction, for: .primaryActionTriggered)
        userPasswordTextField.rightView = changePasswordSecureButton
    }
    
    private func setupToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.sizeToFit()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDismissKeyboard))
        let items = [flexibleSpace,doneButtonItem]
        toolBar.setItems(items, animated: true)
        return toolBar
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
