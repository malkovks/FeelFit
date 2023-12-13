//
//  FFTRainingPlanViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import UserNotifications
import RealmSwift

struct TrainingPlan {
    let firstName: String
    let secondName: String
    let detailTraining: String
    let plannedDate: Date
    let durationMinutes: Int
    let location: String
    let exercises: [Exercise]
}


/// Main view controller which displaying planned if they have trainings. If not - user can create them
class FFTRainingPlanViewController: UIViewController,SetupViewController {
    
    private var viewModel: FFTrainingPlanViewModel!
    
    private let realm = try! Realm()
    private var trainingPlans: Results<FFTrainingPlanRealmModel>!
    
    private var collectionView: UICollectionView!
    
    private var refreshController: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.tintColor = FFResources.Colors.activeColor
        return refresh
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        setupView()
        setupLocalNotificationsAuth()
        DispatchQueue.main.async { [ unowned self ] in
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupViewModel()
       
        setupCollectionView()
        setupRefreshController()
        setupNavigationController()
        setupConstraints()
        view.backgroundColor = FFResources.Colors.backgroundColor
    }

    @objc private func didTapCreateProgram(){
        let vc = FFCreateTrainProgramViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapRefreshView(){
        refreshController.beginRefreshing()
        setupView()
        loadData()
        DispatchQueue.main.async { [ unowned self ] in
            collectionView.reloadData()
            refreshController.endRefreshing()
        }
    }
    
    func loadData(){
        let object = realm.objects(FFTrainingPlanRealmModel.self)
        trainingPlans = object
    }
    
    func setupLocalNotificationsAuth(){
        let userNotification = UNUserNotificationCenter.current()
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert,.badge,.sound)
        userNotification.requestAuthorization(options: authOptions) { [unowned self] status, error in
            guard error == nil else {
                self.viewAlertController(text: error?.localizedDescription, startDuration: 0.5, timer: 2, controllerView: self.view)
                return
            }
        }
    }
    
    func setupView() {
        
        if trainingPlans.isEmpty {
            contentUnavailableConfiguration = viewModel.configurationUnavailableView(action: {
                self.didTapCreateProgram()
            })
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    func setupViewModel() {
        viewModel = FFTrainingPlanViewModel(viewController: self)
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 2
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FFTrainingPlanCollectionViewCell.self, forCellWithReuseIdentifier: FFTrainingPlanCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
        collectionView.refreshControl = refreshController
    }
    
    func setupNavigationController() {
        title = "Train Plan"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "", imageName: "rectangle.badge.plus", action: #selector(didTapCreateProgram), menu: nil)
    }
    
    func setupRefreshController(){
        refreshController.addTarget(self, action: #selector(didTapRefreshView), for: .valueChanged)
    }
}

extension FFTRainingPlanViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trainingPlans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFTrainingPlanCollectionViewCell.identifier, for: indexPath) as! FFTrainingPlanCollectionViewCell
        cell.configureLabels(model: trainingPlans,indexPath: indexPath)
        return cell
    }
}

extension FFTRainingPlanViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(UIResponderStandardEditActions.delete(_:)){
            let model = trainingPlans[indexPath.row]
            FFTrainingPlanStoreManager.shared.deletePlan(model)
            collectionView.deleteItems(at: [indexPath])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration {
            return nil
            //здесь должна быть ссылка на контроллер деталей планируемой тренировки
        } actionProvider: { _ in
            let actionOpen = UIAction(title: "Open", image: UIImage(systemName: "arrow.up.forward.square")) { _ in
                //показывать детали данной программы
            }
            let actionDelete = UIAction(title: "Delete", image: UIImage(systemName: "trash.square"),attributes: .destructive) { _ in
                let index = collectionView.indexPathForItem(at: point)!
                let model = self.trainingPlans[index.row]
                FFTrainingPlanStoreManager.shared.deletePlan(model)
                collectionView.deleteItems(at: indexPaths)
                self.setupView()
            }
            let menu = UIMenu(children: [actionOpen,actionDelete])
            return menu
        }
    }
}

extension FFTRainingPlanViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width-10
        let height = CGFloat(view.frame.size.height/5)
        return CGSize(width: width, height: height)
    }
}

extension FFTRainingPlanViewController: UIContextMenuInteractionDelegate {
    //MARK: - Test delegate method
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let share = UIAction(title: "Share") { _ in
                
            }
            return UIMenu(children: [share])
        }
    }
}

extension FFTRainingPlanViewController {
    private func setupConstraints(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
}
