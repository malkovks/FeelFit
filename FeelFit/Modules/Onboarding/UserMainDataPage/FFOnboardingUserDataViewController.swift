//
//  FFOnboardingUserDataViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 02.03.2024.
//

import UIKit
import PhotosUI
import TipKit

class FFOnboardingUserDataViewController: UIViewController, HandlerUserProfileImageProtocol {
    
    private var isDataLoaded: Bool = false
    
    var cameraPickerController: UIImagePickerController!
    var pickerViewController: PHPickerViewController!
    var viewModel: FFOnboardingUserDataViewModel!
    private weak var tipView: TipUIView?
    
    
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,style: .insetGrouped)
        tableView.register(FFSubtitleTableViewCell.self, forCellReuseIdentifier: FFSubtitleTableViewCell.identifier)
        tableView.setupAppearanceShadow()
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = true
        tableView.flashScrollIndicators()
        tableView.register(FFCenteredTitleTableViewCell.self, forCellReuseIdentifier: FFCenteredTitleTableViewCell.identifier)
        tableView.register(FFSubtitleTableViewCell.self, forCellReuseIdentifier: FFSubtitleTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInlineInfo(titleText: "User Information", messageText: "You can fill out the table manually or download data from the Health application; it will be available if you previously filled it out and gave access to the application. Filling out this information is optional, but recommended.", popoverImage: "heart", arrowEdge: .bottom) { tipView in
            tipView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
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
        if let tipView = tipView {
            tipView.removeFromSuperview()
            self.tipView = nil
        }
    }
}

//MARK: - Action methods from Strategy Pattern HandlerUserProfileImageProtocol
extension FFOnboardingUserDataViewController {
    @objc private func didTapOpenImage(_ sender: UITapGestureRecognizer){
        didTapOpenImagePicker(cameraPickerController, pickerViewController, animated: true, sender)
        reloadTableView()
    }
    
    @objc private func didTapLongPress(_ longGesture: UILongPressGestureRecognizer){
        didTapLongPressOnImage(longGesture)
    }
}


//MARK: - Setup methods
extension FFOnboardingUserDataViewController: SetupViewController {
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupViewModel()
        setupTableView()
        setupNavigationController()
        setupCameraPickerController()
        setupPickerViewController()
        setupConstraints()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationController() { }
    
    func setupViewModel() { 
        viewModel = FFOnboardingUserDataViewModel(viewController: self)
        viewModel.delegate = self
    }
    
    func reloadTableView(){
        DispatchQueue.main.async { [unowned self] in
            tableView.reloadData()
        }
    }
}

//MARK: - Delegate method from OnboardingUserViewModel for returning status of handling data
extension FFOnboardingUserDataViewController: FFOnboardingUserDataProtocol {
    func didUserSavedData(isSaved: Bool) {
        if !isSaved {
            viewAlertController(text: "Error saving data to user manager. Try again later", controllerView: self.view)
        }
    }

    func didLoadUserData(isDataLoaded: Bool) {
        self.isDataLoaded = isDataLoaded
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didReceiveSelectedData(isReceived: Bool, indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
    }
    
}

//MARK: - Delegates for open and handle taken image from Camera
extension FFOnboardingUserDataViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        handlerCapturedImage(info)
        reloadTableView()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//MARK: - Delegate for handle picker image from media
extension FFOnboardingUserDataViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        handlerSelectedImage(results)
    }
}



//MARK: - Table View Data Source
extension FFOnboardingUserDataViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.userDataDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userDataDictionary[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0,1:
            let cell = tableView.dequeueReusableCell(withIdentifier: FFSubtitleTableViewCell.identifier, for: indexPath) as! FFSubtitleTableViewCell
            cell.configureView(userDictionary: viewModel.userDataDictionary, indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: FFCenteredTitleTableViewCell.identifier, for: indexPath) as! FFCenteredTitleTableViewCell
            cell.configureCell(loaded: isDataLoaded, indexPath: indexPath)
            return cell
        }
    }
}

//MARK: - Table View Delegate
extension FFOnboardingUserDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.tableView(tableView, heightForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        viewModel.tableView(tableView, heightForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        viewModel.tableView(tableView, viewForHeaderInSection: section, userImage: userImage, isLabelHidden: true, didTapImage: #selector(didTapOpenImage), longPress: #selector(didTapLongPress), target: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableView(tableView, didSelectRowAt: indexPath)
    }
    

}

extension FFOnboardingUserDataViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().multipliedBy(0.75)
        }
    }
}

#Preview {
    return FFOnboardingUserDataViewController()
}
