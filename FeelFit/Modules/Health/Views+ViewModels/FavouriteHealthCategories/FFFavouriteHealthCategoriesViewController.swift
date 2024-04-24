//
//  FFPresentHealthCollectionView.swift
//  FeelFit
//
//  Created by Константин Малков on 04.02.2024.
//

import HealthKit
import UIKit

///Class displaying filtered collection view with main data of users selected information
class FFFavouriteHealthCategoriesViewController: UIViewController, SetupViewController {
    
    private var viewModel:FFFavouriteUserCategoriesViewModel!
    
    private var collectionView: UICollectionView!
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.tintColor = FFResources.Colors.backgroundColor
        return refresh
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Target methods
    @objc private func didTapPresentUserProfile(){
        viewModel.presentUserProfilePage()
    }
    
    @objc private func didTapRefreshView(){
        viewModel.userFavouriteHealthCategoryArray.removeAll()
        viewModel.refreshView()
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func didTapPressChangeFavouriteCollectionView(){
        viewModel.presentHealthCategories()
    }
    
    //MARK: - Setup view
    func setupView() {
        setupViewModel()
        setupCollectionView()
        
        setGradientBackground(topColor: FFResources.Colors.activeColor, bottom: .secondarySystemBackground)
        setupNavigationController()
        setupRefreshControl()
        setupConstraints()
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
        let image = viewModel.userProfileImage
        let customView = FFNavigationControllerCustomView()
        customView.configureView(title: "Summary",image)
        customView.navigationButton.addTarget(self, action: #selector(didTapPresentUserProfile), for: .primaryActionTriggered)
        navigationItem.titleView = customView
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    func setupViewModel() {
        viewModel = FFFavouriteUserCategoriesViewModel(viewController: self)
        viewModel.delegate = self
        didTapRefreshView()
    }
}

extension FFFavouriteHealthCategoriesViewController: UserHealthCategoryDelegate {
    func didTapReloadView() {
        didTapRefreshView()
    }
}

extension FFFavouriteHealthCategoriesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userFavouriteHealthCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFPresentHealthCollectionViewCell.identifier, for: indexPath) as! FFPresentHealthCollectionViewCell
        let data = viewModel.userFavouriteHealthCategoryArray[indexPath.row]
        cell.configureCell(indexPath, values: data)
        return cell
    }
}

extension FFFavouriteHealthCategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.pushSelectedHealthCategory(selectedItem: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FFPresentHealthHeaderCollectionView.identifier, for: indexPath) as! FFPresentHealthHeaderCollectionView
            header.configureHeaderCollectionView(selector: #selector(didTapPressChangeFavouriteCollectionView), target: self)
            return header
        }
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FFPresentHealthFooterCollectionView.identifier, for: indexPath) as! FFPresentHealthFooterCollectionView
        footer.configureButtonTarget(target: self, selector: #selector(didTapPressChangeFavouriteCollectionView))
        return  footer
    }
}

extension FFFavouriteHealthCategoriesViewController: UICollectionViewDelegateFlowLayout {
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

private extension FFFavouriteHealthCategoriesViewController {
    func setupConstraints(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

#Preview {
    let vc = FFFavouriteHealthCategoriesViewController()
    let navVC = FFNavigationController(rootViewController: vc)
    return navVC
}






