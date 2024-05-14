//
//  FFAccessToServicesViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 28.04.2024.
//

import UIKit

class FFAccessToServicesViewController: UIViewController {
    
    private let cellIdentifier = FFAccessTableViewCell.identifier
    
    private let indicator = UIActivityIndicatorView(frame: .zero)
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,style: .insetGrouped)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private var viewModel: FFAccessToServicesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

extension FFAccessToServicesViewController: SetupViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        title = "Access to services"
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        }
        setupViewModel()
        setupNavigationController()
        setupTableView()
        setupConstraints()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        viewModel.checkUserAccessToServices()
    }
    
    func setupViewModel() {
        viewModel = FFAccessToServicesViewModel(viewController: self)
        viewModel.delegate = self
    }
    
    func setupNavigationController() {
        
    }
    
    private func setupTableView(){
        tableView.register(FFAccessTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(FFAccessHeaderTableView.self, forHeaderFooterViewReuseIdentifier: FFAccessHeaderTableView.identifier)
        tableView.register(FFAccessFooterTableView.self, forHeaderFooterViewReuseIdentifier: FFAccessFooterTableView.identifier)
        tableView.estimatedSectionHeaderHeight = 44
        tableView.estimatedSectionFooterHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
    }
}

extension FFAccessToServicesViewController: AccessToServicesDelegate {
    func didStartLoading() {
        tableView.isHidden = true
        indicator.startAnimating()
    }
    
    func didEndLoading() {
        
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func requestToOpenSystemAppSettings(){
        let alert = UIAlertController(title: "Change access", message: "Do you want to change access of selected value. We will remove You to system settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settings = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(settings)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}

extension FFAccessToServicesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = Mirror(reflecting: viewModel.accessData)
        return data.children.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FFAccessTableViewCell
        cell.configureCell(value: viewModel.accessData, indexPath: indexPath)
        return cell
    }
}

extension FFAccessToServicesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        requestToOpenSystemAppSettings()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FFAccessHeaderTableView.identifier) as! FFAccessHeaderTableView
        header.configureHeaderView(tableView)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: FFAccessFooterTableView.identifier) as! FFAccessFooterTableView
        footer.configureFooterView(tableView)
        return footer
    }
}

extension FFAccessToServicesViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

#Preview {
    let vc = FFAccessToServicesViewController()
    let nav = FFNavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .pageSheet
    nav.isNavigationBarHidden = false
    nav.sheetPresentationController?.detents = [.medium()]
    nav.sheetPresentationController?.prefersGrabberVisible = true
    return nav
}
