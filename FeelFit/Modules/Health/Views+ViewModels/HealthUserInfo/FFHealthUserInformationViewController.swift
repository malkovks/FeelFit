//
//  FFHealthUserInformationViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.02.2024.
//

import UIKit

class FFHealthUserInformationViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFHealthUserInformationViewModel!
    
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    //MARK: - Action methods
    @objc private func didTapDismiss(){
        viewModel.popPresentedController()
    }
    
    @objc private func didTapSaveUserData(){
        viewModel.saveUserData()
    }
    
    //MARK: - Set up methods
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupViewModel()

        setupTableView()
        setupNavigationController()
        setupConstraints()
        
    }
    
    
    func setupViewModel() {
        viewModel = FFHealthUserInformationViewModel(viewController: self)
        viewModel.delegate = self
        viewModel.loadFullUserData()
    }

    func setupNavigationController() {
        title = "Health information"
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "Back", imageName: "", action: #selector(didTapDismiss), menu: nil)
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Save", imageName: "", action: #selector(didTapSaveUserData), menu: nil)
    }

    private func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FFSubtitleTableViewCell.self, forCellReuseIdentifier: FFSubtitleTableViewCell.identifier)
        tableView.register(FFCenteredTitleTableViewCell.self, forCellReuseIdentifier: FFCenteredTitleTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

//MARK: - Table view data source
extension FFHealthUserInformationViewController: UITableViewDataSource {
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

//MARK: - Table view delegate
extension FFHealthUserInformationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
    
    
    //Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        viewModel.tableView(tableView, heightForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.tableView(tableView, heightForHeaderInSection: section)
    }
}

extension FFHealthUserInformationViewController: HealthUserInformationDelegate {
    func didReloadTableView(indexPath: IndexPath?) {
        DispatchQueue.main.async { [unowned self] in
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            } else {
                tableView.reloadData()
            }
        }
    }
    
    
}

private extension FFHealthUserInformationViewController {
    func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

#Preview {
    let navVC = FFNavigationController(rootViewController: FFHealthUserInformationViewController())
    return navVC
}
