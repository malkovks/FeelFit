//
//  FFExercisesViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit

class FFExercisesViewController: UIViewController, SetupViewController {
    
    var viewModel: FFExercisesViewModel!

//    var muscleDictionary = [
//        "abdominals" : "Abdominals",
//        "abductors" : "Abductors",
//        "adductors" : "Adductors",
//        "biceps" : "Biceps",
//        "calves" : "Calves",
//        "chest" : "Chest",
//        "forearms" : "Forearms",
//        "glutes" : "Glutes",
//        "hamstrings" : "Hamstrings",
//        "lats" : "Lats",
//        "lower_back" : "Lower back",
//        "middle_back" : "Middle back",
//        "neck" : "Neck",
//        "quadriceps" : "Quadriceps",
//        "traps" : "Traps",
//        "triceps" : "Triceps"
//    ]
    
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupCollectionView()
        setupConstraints()
    }
    
    func setupView() {
        viewModel = FFExercisesViewModel()
        view.backgroundColor = .secondarySystemBackground
    }
    
    func setupNavigationController() {
        title = "Exercises"
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FFExercisesCollectionViewCell.self, forCellWithReuseIdentifier: FFExercisesCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
}

extension FFExercisesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FFExercisesCollectionViewCell().muscleDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFExercisesCollectionViewCell.identifier, for: indexPath) as! FFExercisesCollectionViewCell
        cell.configureCell(indexPath: indexPath)
        return cell
    }
    
    
}

extension FFExercisesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        viewModel.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath,viewController: self)
    }
}

extension FFExercisesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.collectionView(collectionView, didSelectItemAt: indexPath, viewController: self)
    }
}

extension FFExercisesViewController {
    private func setupConstraints(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
