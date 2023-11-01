//
//  FFExercisesViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit

class FFExercisesViewController: UIViewController, SetupViewController {
    
    var viewModel: FFExercisesViewModel!

    var muscleDictionary = [
        "abdominals" : "Abdominals",
        "abductors" : "Abductors",
        "adductors" : "Adductors",
        "biceps" : "Biceps",
        "calves" : "Calves",
        "chest" : "Chest",
        "forearms" : "Forearms",
        "glutes" : "Glutes",
        "hamstrings" : "Hamstrings",
        "lats" : "Lats",
        "lower_back" : "Lower back",
        "middle_back" : "Middle back",
        "neck" : "Neck",
        "quadriceps" : "Quadriceps",
        "traps" : "Traps",
        "triceps" : "Triceps"
    ]
    
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
        muscleDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFExercisesCollectionViewCell.identifier, for: indexPath) as! FFExercisesCollectionViewCell
        let key = Array(muscleDictionary.keys.sorted())[indexPath.row]
        let value = muscleDictionary[key]
        cell.configureCell(text: value)
        return cell
    }
    
    
}

extension FFExercisesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 10
        let height = CGFloat(view.frame.size.height/4)
        return CGSize(width: width, height: height)
    }
}

extension FFExercisesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = Array(muscleDictionary.keys.sorted())[indexPath.row]
        let vc = FFExercisesMuscleGroupViewController()
        vc.loadData(name: name)
        navigationController?.pushViewController(vc, animated: true)
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
