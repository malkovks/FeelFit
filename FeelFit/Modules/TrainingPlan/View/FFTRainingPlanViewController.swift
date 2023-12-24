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

enum PlanTrainingSortType: String {
    case date = "By Date"
    case name = "By Name"
    case type = "By Type"
    case location = "By Location"
}


/// Main view controller which displaying planned if they have trainings. If not - user can create them
class FFTRainingPlanViewController: UIViewController,SetupViewController {
    
    private var viewModel: FFTrainingPlanViewModel!
    
    private let realm = try! Realm()
    private var trainingPlans: [FFTrainingPlanRealmModel]!
    
    private var collectionView: UICollectionView!
    
    private var refreshController: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.tintColor = FFResources.Colors.activeColor
        return refresh
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData(sorted: .date)
        setupView()
        setupLocalNotificationsAuth()
        DispatchQueue.main.async { [ unowned self ] in
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData(sorted: .date)
        setupViewModel()
       
        setupCollectionView()
        setupRefreshController()
        setupNavigationController()
        setupConstraints()
        view.backgroundColor = FFResources.Colors.backgroundColor
        
        
    }

    @objc func didTapCreateProgram(){
        let vc = FFCreateTrainProgramViewController(isViewEditing: false, trainPlanData: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapRefreshView(){
        refreshController.beginRefreshing()
        setupView()
        loadData(sorted: .date)
        DispatchQueue.main.async { [ unowned self ] in
            collectionView.reloadData()
            refreshController.endRefreshing()
        }
    }
    
    func loadData(sorted: PlanTrainingSortType){
        //MARK: - Доделать
        switch sorted {
        case .date:
            trainingPlans = realm.objects(FFTrainingPlanRealmModel.self).sorted(by: { $0.trainingDate > $1.trainingDate })
        case .name:
            trainingPlans = realm.objects(FFTrainingPlanRealmModel.self).sorted(by: { $0.trainingName > $1.trainingName })
        case .type:
            trainingPlans = realm.objects(FFTrainingPlanRealmModel.self).sorted(by: { $0.trainingType ?? "Default" > $1.trainingType ?? "Default" })
        case .location:
            trainingPlans = realm.objects(FFTrainingPlanRealmModel.self).sorted(by: { $0.trainingLocation ?? "Default" > $1.trainingLocation ?? "Default" })
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "", imageName: "line.3.horizontal.decrease", action: nil, menu: setupSortingMenu())
    }
    
    
    
    func setupSortingMenu() -> UIMenu {
        var actions: [UIAction] {
            return [
                UIAction(title: "By Date", handler: { [unowned self] _ in
                    loadData(sorted: .date)
                }),
                UIAction(title: "By Name", handler: { [unowned self] _ in
                    loadData(sorted: .name)
                }),
                UIAction(title: "By Type", handler: { [unowned self] _ in
                    loadData(sorted: .type)
                }),
                UIAction(title: "By Location", handler: { [unowned self] _ in
                    loadData(sorted: .location)
                }),]
        }
        let menu = UIMenu(title: "Sort type",options: .singleSelection,children: actions)
        return menu
    }
    
    func setupRefreshController(){
        refreshController.addTarget(self, action: #selector(didTapRefreshView), for: .valueChanged)
    }
    
    func openPlanDetail(_ model: FFTrainingPlanRealmModel){
        let vc = FFPlanDetailsViewController(data: model)
        let nav = FFNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.isNavigationBarHidden = false
        present(nav, animated: true)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = trainingPlans[indexPath.row]
        openPlanDetail(data)
    }
    
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
        let index = collectionView.indexPathForItem(at: point)!
        let model = trainingPlans[index.row]
        let vc = FFPlanDetailsViewController(data: model)
        return UIContextMenuConfiguration {
            return vc
        } actionProvider: { _ in
            let actionOpen = UIAction(title: "Open", image: UIImage(systemName: "arrow.up.forward.square")) { _ in
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let actionDelete = UIAction(title: "Delete", image: UIImage(systemName: "trash.square"),attributes: .destructive) { [unowned self] _ in
                FFTrainingPlanStoreManager.shared.deletePlan(model)
                trainingPlans.remove(at: index.row)
                collectionView.deleteItems(at: indexPaths)
                self.setupView()
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
            let actionChange = UIAction(title: "Change", image: UIImage(systemName: "gear")) { _ in
                //подумать как изменять данные выбранной модели
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
