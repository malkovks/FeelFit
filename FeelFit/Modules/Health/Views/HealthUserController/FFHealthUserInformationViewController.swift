//
//  FFHealthUserInformationViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.02.2024.
//

import UIKit

class FFHealthUserInformationViewController: UIViewController, SetupViewController {
    
    private let tableViewText: [[String]] = [["Name","Second Name"],["Birthday","Gender","Blood Type","Skin Type(Fitzpatrick Type)"],["Stoller chair"]]
    private var usersData: UserCharactersData = UserCharactersData()
    
    private var userDataDictionary: [[String: String]] = [
        ["Name":"Kostia","Second Name": "Malkov"],
        ["Birthday":"21.10.1995","Gender":"Male","Blood Type":"A+","Skin Type(Fitzpatrick Type)":"Not Set"],
        ["Stoller chair":"Not Set"]
    ]
    
    private var isTableViewIsEditing: Bool = false
    
    var userImage: UIImage? = UIImage(systemName: "person.crop.circle")!
    
    private var userImageView: UIImageView!
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        FFHealthDataLoading.shared.loadingCharactersData { [weak self] userDataString in
            guard let data = userDataString else { return }
            self?.usersData = data
        }
    }
    
    //MARK: - Action methods
    @objc private func didTapDismiss(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapEditTableView(){
        
        if !isTableViewIsEditing {
            tableView.isEditing = true
            tableView.setEditing(true, animated: true)
            isTableViewIsEditing.toggle()
        } else {
            tableView.isEditing = false
            tableView.setEditing(false, animated: true)
            isTableViewIsEditing.toggle()
        }
    }
    
    //MARK: - Set up methods
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupUserImageView()
        setupTableView()
        setupViewModel()
        setupNavigationController()
        setupConstraints()
    }
    
    func setupViewModel() {
        
    }

    func setupNavigationController() {
        title = "Health information"
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "Back", imageName: "", action: #selector(didTapDismiss), menu: nil)
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Edit", imageName: "", action: #selector(didTapEditTableView), menu: nil)
    }

    private func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FFSubtitleTableViewCell.self, forCellReuseIdentifier: FFSubtitleTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupUserImageView(){
        userImageView = UIImageView(image: userImage)
        userImageView.frame = CGRectMake(0, 0, view.frame.size.width/5, view.frame.size.width/5)
        userImageView.tintColor = FFResources.Colors.activeColor
        userImageView.setupShadowLayer()
        userImageView.isUserInteractionEnabled = true
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.layer.masksToBounds = true
        userImageView.contentMode = .scaleAspectFill
    }

}

extension FFHealthUserInformationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return userDataDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataDictionary[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFSubtitleTableViewCell.identifier, for: indexPath) as! FFSubtitleTableViewCell
        cell.configureView(userDictionary: userDataDictionary, indexPath)
        return cell
    }
}

extension FFHealthUserInformationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let cell = tableView.cellForRow(at: indexPath) as? FFSubtitleTableViewCell
        if !tableView.isEditing {
            cell?.configureEditingCell(false)
            
            return .none
        } else if tableView.isEditing == true {
            cell?.configureEditingCell(true)
            return .none
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        let _ = tableView.cellForRow(at: indexPath!) as! FFSubtitleTableViewCell
        if tableView.isEditing == false {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            print("Open text field")
        case 1:
            print("Open picker view")
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
    //Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    //Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frameRect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: view.frame.size.height/4 - 10)
        let customView = UserImageTableViewHeaderView(frame: frameRect)
        customView.configureCustomHeaderView(userImage: nil,isLabelHidden: true)
        return customView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return view.frame.size.height/5
        } else {
            return 0
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
    let navVC = UINavigationController(rootViewController: FFHealthUserInformationViewController())
    return navVC
}
