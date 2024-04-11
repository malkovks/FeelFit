//
//  FFOnboardingAuthenticationViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.03.2024.
//

import UIKit
import TipKit


class FFOnboardingAuthenticationViewController: UIViewController {
    
    var viewModel: FFOnboardingAuthenticationViewModel!
    
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
    
    private let deleteAccountButton: UIButton = {
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
        removeTipView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        removeTipView()
    }
    
    //MARK: - Target methods
    
    @objc private func didTapLogout(){
        viewModel.logoutFromAccount()
    }
    
    //Create account
    @objc private func didTapCreateNewAccount(){
        let account = getUserAccountData()
        viewModel.createNewAccount(user: account)
        
    }
    //Log in to account
    @objc private func didTapLogin(){
        let account = getUserAccountData()
        viewModel.loginToAccount(user: account)
    }
    
    //Update password or delete account
    @objc private func didTapDeleteAccount(){
        let account = getUserAccountData()
        viewModel.deleteAccount(user: account)
    }
}

extension FFOnboardingAuthenticationViewController: SetupViewController {
    func removeTipView(){
        if let tipView = tipView {
            tipView.removeFromSuperview()
            self.tipView = nil
        }
    }
    
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupUserConfirmButton()
        setupTextFields()
        setupNavigationController()
        setupViewModel()
        setupConstraints()
    }
    
    private func getUserAccountData() -> CredentialUser? {
        guard let emailText = userEmailTextField.text,
              let password = userPasswordTextField.text else {
            viewAlertController(text: "Fill all fields correctly", controllerView: self.view)
            return nil
        }
        return CredentialUser(email: emailText, password: password)
    }
    
    private func setupUserConfirmButton(){
        logoutAccountButton.isHidden = true
        logoutAccountButton.addTarget(self, action: #selector(didTapLogout), for: .primaryActionTriggered)
        createAccountButton.addTarget(self, action: #selector(didTapCreateNewAccount), for: .primaryActionTriggered)
        loginAccountButton.addTarget(self, action: #selector(didTapLogin), for: .primaryActionTriggered)
        deleteAccountButton.addTarget(self, action: #selector(didTapDeleteAccount), for: .primaryActionTriggered)
    }
    
    private func clearTextFields(){
        userEmailTextField.text = nil
        userPasswordTextField.text = nil
        confirmButton(completed: false)
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
    
    private func confirmButton(completed: Bool){
        if completed {
            UIView.animate(withDuration: 0.2) { [unowned self] in
                loginAccountButton.alpha = 0
                createAccountButton.alpha = 0
                logoutAccountButton.alpha = 1
                deleteAccountButton.alpha = 1
            } completion: { [unowned self] _ in
                loginAccountButton.isHidden = true
                createAccountButton.isHidden = true
                logoutAccountButton.isHidden = false
                userEmailTextField.isHidden = true
                userPasswordTextField.isHidden = true
                deleteAccountButton.isHidden = false
                view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2) { [unowned self] in
                loginAccountButton.alpha = 1
                createAccountButton.alpha = 1
                logoutAccountButton.alpha = 0
                deleteAccountButton.alpha = 0
            } completion: { [unowned self] _ in
                loginAccountButton.isHidden = false
                createAccountButton.isHidden = false
                logoutAccountButton.isHidden = true
                deleteAccountButton.isHidden = true
                userEmailTextField.isHidden = false
                userPasswordTextField.isHidden = false
                view.layoutIfNeeded()
            }
            userEmailTextField.text = ""
            userPasswordTextField.text = ""
        }
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
        viewModel = FFOnboardingAuthenticationViewModel(viewController: self)
        viewModel.delegate = self
    }
}

extension FFOnboardingAuthenticationViewController: FFAuthenticationDelegate {
    func didClearTextFields() {
        clearTextFields()
    }
    
    func didTapConfirmButtons(completed: Bool) {
        confirmButton(completed: completed)
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
        authStackView.addArrangedSubview(deleteAccountButton)
        
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
    }
}

#Preview {
    let navVC = UINavigationController(rootViewController: FFOnboardingAuthenticationViewController())
    return navVC
}
