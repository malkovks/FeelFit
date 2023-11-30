//
//  FFMusclesGroupViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import RealmSwift

class FFMusclesGroupViewController: UIViewController, SetupViewController {
    
    var viewModel: FFMuscleGroupViewModel!
    
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        
        let realm = try! Realm()
        print(realm.configuration.fileURL!)
        
        contentUnavailableConfiguration = viewModel.setupConfiguration { [unowned self] in
            setupCollectionView()
            setupConstraints()
            contentUnavailableConfiguration = nil
        }
    }
    
    @objc private func didTapOpenFavourite(){
        let vc = FFFavouriteExercisesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapDelete(){
        viewModel.clearModelByName()
    }
    
    func setupView() {
        viewModel = FFMuscleGroupViewModel(viewController: self)
        view.backgroundColor = .secondarySystemBackground
    }
    
    func setupNavigationController() {
        title = "Exercises"
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "", imageName: "heart.fill", action: #selector(didTapOpenFavourite), menu: nil)
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "", imageName: "trash", action: #selector(didTapDelete), menu: nil)
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FFExercisesCollectionViewCell.self, forCellWithReuseIdentifier: FFExercisesCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
}

extension FFMusclesGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FFExercisesCollectionViewCell().muscleDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFExercisesCollectionViewCell.identifier, for: indexPath) as! FFExercisesCollectionViewCell
        cell.configureCell(indexPath: indexPath)
        return cell
    }
    
    
}

extension FFMusclesGroupViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
}

extension FFMusclesGroupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

extension FFMusclesGroupViewController {
    private func setupConstraints(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
