    //
//  FFUserProfileViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 25.01.2024.
//

import UIKit
import Photos
import PhotosUI
import AVFoundation
import RealmSwift
import TipKit



///Class display main information about user, his basic statistics and some terms about health access and etc
class FFUserProfileViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFUserProfileViewModel!
    
    private var tableView: UITableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    //MARK: - Target methods
    @objc private func didTapDismiss(){
        dismiss(animated: true)
    }
}

    //MARK: Set up methods
extension FFUserProfileViewController {
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupViewModel()
        
        FFHealthDataAccess.shared.requestAccessToCharactersData()
        setupNavigationController()
        setupTableView()
        setupConstraints()
    }

    
    func setupNavigationController() {
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Done", imageName: "", action: #selector(didTapDismiss), menu: nil)
        FFNavigationController().navigationBar.backgroundColor = .secondarySystemBackground
    }
    

    func setupViewModel() {
        viewModel = FFUserProfileViewModel(viewController: self)
        viewModel.loadUserData()
    }
    
    private func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FFUserProfileTableViewCell.self, forCellReuseIdentifier: FFUserProfileTableViewCell.identifier)
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .clear
        tableView.bounces = true
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 44
        tableView.setupAppearanceShadow()
    }
}


//MARK: - TableView Data Source
extension FFUserProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.tableView(tableView, cellForRowAt: indexPath)
    }
}

extension FFUserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableView(tableView, didSelectRowAt: indexPath)
    }
    
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
        viewModel.tableView(tableView, viewForHeaderInSection: section)
    }
}

extension FFUserProfileViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
}

#Preview {
    let vc = FFNavigationController(rootViewController: FFUserProfileViewController())
    return vc
}
