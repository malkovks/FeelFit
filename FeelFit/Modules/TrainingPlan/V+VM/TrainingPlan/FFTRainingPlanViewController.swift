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
    private var sortingValue: String = UserDefaults.standard.string(forKey: "planSortKey") ?? "trainingDate"
    private var trainingPlans: [FFTrainingPlanRealmModel]!
    
    private var timer: Timer?
    
    private var collectionView: UICollectionView!
    
    private var refreshController: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero)
        refresh.tintColor = FFResources.Colors.activeColor
        return refresh
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocalNotificationsAuth()
        setupView()
        setupViewModel()
        loadData(sorted: sortingValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        loadData(sorted: sortingValue)
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
        loadData(sorted: sortingValue)
        DispatchQueue.main.async { [ unowned self ] in
            collectionView.reloadData()
            refreshController.endRefreshing()
        }
    }
    
    func loadData(sorted: String){
        trainingPlans = [FFTrainingPlanRealmModel]()
        trainingPlans =  viewModel.startLoadingPlans(sorted)
        if !trainingPlans.isEmpty {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.contentUnavailableConfiguration = nil
            }
        } else {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.contentUnavailableConfiguration = self.viewModel.configurationUnavailableView {
                    self.didTapCreateProgram()
                }
            }
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
        navigationItem.leftBarButtonItem = addNavigationBarButton(title: "", imageName: "line.3.horizontal.decrease", action: nil, menu: setupMenu())
    }
    
    //MARK: - Menu setups
    private func sortTypeMenu() -> UIMenu {
        let sortMenu = UIMenu(title: "Sorting By",image: UIImage(systemName: "line.3.horizontal.decrease.circle"), options: .singleSelection, children: [
            UIAction(title: "Date",image: UIImage(systemName: "calendar"), handler: { [unowned self] _ in
                UserDefaults.standard.setValue("trainingDate", forKey: "planSortKey")
                sortingValue = "trainingDate"
                didTapRefreshView()
                
            }),
            UIAction(title: "Name",image: UIImage(systemName: "character"), handler: { [unowned self] _ in
                UserDefaults.standard.setValue("trainingName", forKey: "planSortKey")
                sortingValue = "trainingName"
                didTapRefreshView()
            })
        ])
        return sortMenu
    }
    
    private func sortStyleMenu() -> UIMenu {
        let sortStyleMenu = UIMenu(title: "Sort Type",image: UIImage(systemName: "chevron.up.chevron.down"), options: .singleSelection, children: [
            UIAction(title: "By Increase",image: UIImage(systemName: "chevron.up"),handler: { [unowned self] _ in
                UserDefaults.standard.setValue(true, forKey: "planSortValueType")
                didTapRefreshView()
                }),
            UIAction(title: "By decrease",image: UIImage(systemName: "chevron.down"),handler: { [unowned self] _ in
                UserDefaults.standard.setValue(false, forKey: "planSortValueType")
                didTapRefreshView()
            })
        ])
        return sortStyleMenu
    }
    
    private func setupMenu() -> UIMenu {
        let sortMenu = sortTypeMenu()
        let styleMenu = sortStyleMenu()
        let menu = UIMenu(title: "Sort type",image: UIImage(systemName: "pencil"),options: .singleSelection,children: [
            UIAction(title: "Completed Trainings",image: UIImage(systemName: "figure.highintensity.intervaltraining"),handler: {  [unowned self] _ in
                let vc = FFPlanCompletedTrainingViewController()
                navigationController?.pushViewController(vc, animated: true)
            }),
            UIAction(title: "Search by Date",image: UIImage(systemName: "magnifyingglass"), handler: { _ in
                self.alertError(title: "Opening calendar picker ")
            }),
            sortMenu,
            styleMenu
        ])
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
    
    func startTimer(_ index: Int){
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
            self?.deleteSelectedCell(index)
        })
    }
    
    func deleteSelectedCell(_ index: Int){
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            try! realm.write({
                trainingPlans[index].trainingCompleteStatus = true
            })
            self.trainingPlans.remove(at: index)
            
        } completion: { [weak self] _ in
            
            self?.resetTimer()
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension FFTRainingPlanViewController: TrainingPlanCompleteStatusProtocol {
    func planStatusWasChanged(status: Bool,arrayPlace: Int ) {
        if status {
            resetTimer()
            startTimer(arrayPlace)
            
        } else {
            resetTimer()
        }
        try! realm.write({
            trainingPlans[arrayPlace].trainingCompleteStatus = true
        })
    }
}

extension FFTRainingPlanViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trainingPlans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFTrainingPlanCollectionViewCell.identifier, for: indexPath) as! FFTrainingPlanCollectionViewCell
        cell.delegate = self
        cell.configureLabels(model: trainingPlans,indexPath: indexPath, sortingType: sortingValue)
        return cell
    }
}

extension FFTRainingPlanViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.collectionView(collectionView, didSelectItemAt: indexPath, trainingPlans)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let indexPath = IndexPath(row: 0, section: 0)
        let index = collectionView.indexPathForItem(at: point) ?? indexPath
        let model = trainingPlans[index.row]
        let vc = FFPlanDetailsViewController(data: model)
        let cell = collectionView.cellForItem(at: index) as! FFTrainingPlanCollectionViewCell
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
            let actionChangeStatus = UIAction(title: "Change complete status", image: UIImage(systemName: "checkmark.square")) { _ in
                cell.didTapSave()
            }
            let menu = UIMenu(children: [actionOpen,actionDelete,actionChangeStatus])
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
