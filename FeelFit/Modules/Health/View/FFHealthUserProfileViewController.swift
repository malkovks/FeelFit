//
//  FFHealthUserProfileViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 25.01.2024.
//

import UIKit

class FFHealthUserProfileViewController: UIViewController, SetupViewController {
    
    private let headerTextSections = [
        "",
        "Functions",
        "Сonfidentiality"
    ]
    
    private var scrollView: UIScrollView = UIScrollView(frame: .zero)
    private var userImageView: UIImageView = UIImageView(frame: .zero)
    private var userFullNameLabel: UILabel = UILabel(frame: .zero)
    private var tableView: UITableView = UITableView(frame: .zero)


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    //MARK: - Target methods
    @objc private func didTapDismiss(){
        self.dismiss(animated: true)
    }
    
    
    //MARK: Set up methods
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupNavigationController()
        setupViewModel()
        setupTableView()
        setupUserLabel()
        setupUserImageView()
        setupScrollView()
        setupConstraints()
    }
    
    func setupNavigationController() {
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Done", imageName: "", action: #selector(didTapDismiss), menu: nil)
        FFNavigationController().navigationBar.backgroundColor = .secondarySystemBackground
    }
    
    func setupViewModel() {
        
    }
    
    private func setupUserImageView(){
        userImageView = UIImageView(image: UIImage(systemName: "person.crop.circle"))
        userImageView.tintColor = FFResources.Colors.activeColor
        userImageView.layer.cornerRadius = 12
        userImageView.layer.masksToBounds = true
        userImageView.isUserInteractionEnabled = true
    }
    
    private func setupUserLabel(){
        userFullNameLabel = UILabel(frame: .zero)
        userFullNameLabel.text = "Malkov Konstantin"
        userFullNameLabel.font = UIFont.headerFont(size: 24)
        userFullNameLabel.textAlignment = .center
        userFullNameLabel.numberOfLines = 1
    }
    
    private func setupScrollView(){
        scrollView = UIScrollView(frame: .zero)
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userHealthCell")
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.bounces = false
    }
}

extension FFHealthUserProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        headerTextSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userHealthCell", for: indexPath)
        cell.backgroundColor = .systemBackground
        cell.textLabel?.text = "Section number \(indexPath.section) and Text Label at index path \(indexPath.row)"
        return cell
    }
}

extension FFHealthUserProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 5, y: 2, width: tableView.frame.width-10, height: 26))
        label.font = UIFont.textLabelFont(size: 24)
        label.text = headerTextSections[section]
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        customView.addSubview(label)
        return customView
    }
}

extension FFHealthUserProfileViewController {
    private func setupConstraints(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let imageSize = view.frame.size.width/5
        
        scrollView.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(imageSize)
        }
        
        scrollView.addSubview(userFullNameLabel)
        userFullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        scrollView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(userFullNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(view.frame.size.height).multipliedBy(1.2)
            make.width.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.bottom.equalTo(tableView.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width)
        }
        
    }
}
