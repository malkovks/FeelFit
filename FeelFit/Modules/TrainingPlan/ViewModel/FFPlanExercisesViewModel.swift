//
//  FFPlanExercisesViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 04.12.2023.
//

import UIKit
import RealmSwift

class FFPlanExercisesViewModel {
    let viewController: UIViewController
    
    private let realm = try! Realm()
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        
    }
    
    weak var delegate: FFExerciseProtocol?
    
    func loadData(key: String, filter type: String){
        delegate?.viewWillLoadData()
        FFGetExercisesDataBase.shared.getMuscleDatabase(muscle: key,filter: type) { [weak self] result in
            switch result {
            case .success(let success):
                self?.delegate?.viewDidLoadData(result: .success(success))
            case .failure(let failure):
                self?.delegate?.viewDidLoadData(result: .failure(failure))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint,loadData: [Exercise]?, boolean status: Bool,saveAction: @escaping () -> ()) -> UIContextMenuConfiguration? {
        guard let longGesturedData = loadData?[indexPath.row] else { return nil}
        let vc = FFExerciseDescriptionViewController(exercise: longGesturedData, isElementsHidden: true)
        let title = status ? "Remove from Favourite" : "Add To Favourite"
        let image = status ? "heart.fill" : "heart"
        guard let interaction = tableView.contextMenuInteraction else { return nil}
        return setupConfiguration(title: title, imageString: image, vc: vc, data: longGesturedData, interaction: interaction) {
            saveAction()
        }
    }
    
    func setupConfiguration(title: String,imageString: String, vc: UIViewController,data: Exercise,interaction: UIContextMenuInteraction,dataAction: @escaping ()->()) -> UIContextMenuConfiguration{
        let configuration = UIContextMenuConfiguration(identifier: nil) {
            return vc
        } actionProvider: { action in
            let openAction = UIAction(title: "Open details") { [unowned self] action in
                viewController.navigationController?.pushViewController(vc, animated: true)
            }
            
            let addFavourite = UIAction(title: title,image: UIImage(systemName: imageString)?.withTintColor(FFResources.Colors.activeColor,renderingMode: .alwaysOriginal)) { _ in
                dataAction()
                interaction.dismissMenu()
            }
            let closeAction = UIAction(title: "Close preview",image: UIImage(systemName: "xmark")) { _ in
                interaction.dismissMenu()
            }
            var menu: UIMenu = UIMenu(title: "Actions", image: UIImage(systemName: "gear.badge"), children: [openAction, addFavourite,closeAction])
            return menu
        }
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,loadedData: [Exercise]?,selectedExercise: [Exercise],updateAction: () -> Void) -> [Exercise]{
        updateAction()
        let cell = tableView.cellForRow(at: indexPath) as! FFExercisesMuscleTableViewCell
        cell.accessoryType = .checkmark
        guard let data = loadedData else { return [Exercise]() }
        let value = data[indexPath.row]
        var selectedExercise = selectedExercise
        selectedExercise.append(value)
        return selectedExercise
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath,_ loadData: [Exercise]?,exercises deselectedExercises: [Exercise],action: ()->()) -> [Exercise] {
        action()
        let cell = tableView.cellForRow(at: indexPath) as! FFExercisesMuscleTableViewCell
        cell.accessoryType = .none
        guard let data = loadData else { return deselectedExercises }
        let item = data[indexPath.row]
        var selectedExercise: [Exercise] = deselectedExercises
        guard let index: Int = selectedExercise.firstIndex(where: { $0.exerciseID == item.exerciseID }) else { return selectedExercise }
        selectedExercise.remove(at: index)
        return selectedExercise
    }
    
    
}
