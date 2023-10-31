//
//  FFExercisesViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit

class FFExercisesViewController: UIViewController, SetupViewController {
    
    var viewModel: FFExercisesViewModel!
    
    var muscleGroupsName = ["abdominals",
                     "abductors",
                     "adductors",
                     "biceps",
                     "calves",
                     "chest",
                     "forearms",
                     "glutes",
                     "hamstrings",
                     "lats",
                     "lower_back",
                     "middle_back",
                     "neck",
                     "quadriceps",
                     "traps",
                     "triceps"]
    
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupCollectionView()
        setupConstraints()
//        FFGetExerciseRequest.shared.getRequest { result in
//            switch result {
//                
//            case .success(let data):
//                print(data[2])
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    func setupView() {
        viewModel = FFExercisesViewModel()
        view.backgroundColor = .systemGray2
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
        collectionView.backgroundColor = .systemFill
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
}

extension FFExercisesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        muscleGroupsName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFExercisesCollectionViewCell.identifier, for: indexPath) as! FFExercisesCollectionViewCell
        let name = muscleGroupsName[indexPath.row]
        cell.configureCell(text: name)
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
        let name = muscleGroupsName[indexPath.row]
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
