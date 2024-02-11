//
//  FFPresentHealthCollectionView.swift
//  FeelFit
//
//  Created by Константин Малков on 04.02.2024.
//

import HealthKit
import UIKit

class FFPresentHealthCollectionView: UIViewController, SetupViewController {
    
    var userImagePartialName = UserDefaults.standard.string(forKey: "userProfileFileName") ?? "userImage.jpeg"
    
    
    private var userFavouriteTypes: [HKQuantityTypeIdentifier] = FFHealthData.favouriteQuantityTypeIdentifier
    private let loadHealthData = FFHealthDataLoading.shared
    private var healthData = [[FFUserHealthDataProvider]]()
    
    private var collectionView: UICollectionView!
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.tintColor = FFResources.Colors.backgroundColor
        return refresh
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        FFHealthDataAccess.shared.getHealthAuthorizationRequestStatus()
        FFHealthDataAccess.shared.requestForAccessToHealth()
    }
    
    //MARK: - Target methods
    @objc private func didTapPresentUserProfile(){
        let vc = FFHealthUserProfileViewController()
        let navVC = FFNavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    @objc private func didTapRefreshView(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
            self?.prepareCollectionViewData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc private func didTapPressChangeFavouriteCollectionView(){
        let vc = FFFavouriteHealthDataViewController()
        let navVC = FFNavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = false
        present(navVC, animated: true) { [weak self] in
            self?.didTapRefreshView()
        }
    }
    
    @objc private func didTapOpenDetails(){
        let vc = FFHealthViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapOpenSelectedProvider(selectedItem indexPath: IndexPath){
        let data = healthData[indexPath.row]
        let vc = FFMainHealthDataViewController(chartData: data)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Setup view
    func setupView() {
        setGradientBackground(topColor: FFResources.Colors.activeColor, bottom: .secondarySystemBackground)
        setupNavigationController()
        setupCollectionView()
        prepareCollectionViewData()
        setupRefreshControl()
        setupViewModel()
        setupConstraints()
    }
    
    private func prepareCollectionViewData(){
        userFavouriteTypes = FFHealthData.favouriteQuantityTypeIdentifier
        healthData.removeAll()
        loadHealthData.performQuery(identifications: userFavouriteTypes,selectedOptions: nil) { models in
            self.healthData.append(models)
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FFPresentHealthCollectionViewCell.self, forCellWithReuseIdentifier: FFPresentHealthCollectionViewCell.identifier)
        collectionView.register(FFPresentHealthHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FFPresentHealthHeaderCollectionView.identifier)
        collectionView.register(FFPresentHealthFooterCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FFPresentHealthFooterCollectionView.identifier)
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
        navigationController?.navigationBar.backgroundColor = .clear
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
        cell.configureCell(indexPath, values: healthData[indexPath.row])
        return cell
    }
}

extension FFPresentHealthCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        didTapOpenSelectedProvider(selectedItem: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FFPresentHealthHeaderCollectionView.identifier, for: indexPath) as! FFPresentHealthHeaderCollectionView
            header.setupHeaderFavouritesButton.addTarget(self, action: #selector(didTapPressChangeFavouriteCollectionView), for: .primaryActionTriggered)
            return header
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FFPresentHealthFooterCollectionView.identifier, for: indexPath) as! FFPresentHealthFooterCollectionView
        footer.segueFooterButton.addTarget(self, action: #selector(didTapOpenDetails), for: .primaryActionTriggered)
        return  footer
    }
}

extension FFPresentHealthCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width-20
        let height = CGFloat(view.frame.size.height/4)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width-10, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width-10, height: 60)
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


