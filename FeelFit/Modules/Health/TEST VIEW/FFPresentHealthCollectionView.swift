//
//  FFPresentHealthCollectionView.swift
//  FeelFit
//
//  Created by Константин Малков on 04.02.2024.
//

import HealthKit
import UIKit

class FFPresentHealthCollectionView: UIViewController, SetupViewController {
    
    private var userImagePartialName = UserDefaults.standard.string(forKey: "userProfileFileName") ?? "userImage.jpeg"
    
    private let loadHealthData = FFHealthDataLoading.shared
    private var healthData: [FFUserHealthDataProvider] = []
    
    private var collectionView: UICollectionView!
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.tintColor = FFResources.Colors.activeColor
        return refresh
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    //MARK: - Target methods
    @objc private func didTapPresentUserProfile(){
        let vc = FFHealthUserProfileViewController()
        let navVC = FFNavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    @objc private func didTapRefreshView(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc private func didTapOpenView(){
        let vc = FFHealthViewController()
        show(vc, sender: nil)
    }
    
    //MARK: - Setup view
    func setupView() {
        view.backgroundColor = .secondarySystemBackground
        setupNavigationController()
        loadHealthData.performQuery { models in
            self.healthData = models
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        setupCollectionView()
        setupRefreshControl()
        setupViewModel()
        setupConstraints()
        
    }
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FFPresentHealthCollectionViewCell.self, forCellWithReuseIdentifier: FFPresentHealthCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
    }
    
    private func setupRefreshControl(){
        refreshControl.addTarget(self, action: #selector(didTapRefreshView), for: .valueChanged)
    }
    
    func setupNavigationController() {
        let image = loadUserImageWithFileManager(userImagePartialName)!
        let customView = FFNavigationControllerCustomView()
        customView.configureView(title: "Summary",image)
        customView.navigationButton.addTarget(self, action: #selector(didTapPresentUserProfile), for: .primaryActionTriggered)
        navigationItem.titleView = customView
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(didTapOpenView))
    }
    
    func setupViewModel() {
        
    }

}

extension FFPresentHealthCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return healthData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFPresentHealthCollectionViewCell.identifier, for: indexPath) as! FFPresentHealthCollectionViewCell
        cell.configureCell(indexPath, values: healthData)
        
        return cell
    }
}

extension FFPresentHealthCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension FFPresentHealthCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width-10
        let height = CGFloat(view.frame.size.height/4)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}

private extension FFPresentHealthCollectionView {
    func setupConstraints(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
