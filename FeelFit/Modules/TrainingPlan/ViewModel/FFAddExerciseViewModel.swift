//
//  FFAddExerciseViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 01.12.2023.
//

import UIKit


class FFAddExerciseViewModel {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func didTapConfirmSaving(plan: CreateTrainProgram?,exercises: [Exercise]){
        viewController.alertControllerActionConfirm(title: "Warning", message: "Save created program?", confirmActionTitle: "Save", secondTitleAction: "Don't save", style: .actionSheet) { [ unowned self] in
            savePlanProgram(basic: plan, exercises: exercises)
            viewController.navigationController?.popToRootViewController(animated: true)
        } secondAction: { [unowned self] in
            viewController.navigationController?.popToRootViewController(animated: true)
        }
    }
    
//    func loadImage(_ link: String, tableView: UITableView,handler: @escaping ((Data) -> ())){
//        guard let url = URL(string: link) else { return }
//        URLSession.shared.dataTask(with: url) { data ,_,_ in
//            if let data = data {
//                handler(data)
//                DispatchQueue.main.async {
//                    tableView.reloadData()
//                }
//            }
//        }.resume()
//    }
    
    func savePlanProgram(basic: CreateTrainProgram?,exercises: [Exercise]){
        guard let data = basic else { return }
        FFTrainingPlanStoreManager.shared.savePlan(plan: data, exercises: exercises)
        createNotification(data)
    }
    
    private func createNotification(_ model: CreateTrainProgram){
        let sound = UNNotificationSound(named: UNNotificationSoundName("ding.mp3"))
        guard let image = Bundle.main.url(forResource: "arnold_run", withExtension: "jpeg") else {
            print("Error getting image")
            return
        }
        
        let dateComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: model.date)
        let id = UUID().uuidString
        let attachment = try! UNNotificationAttachment(identifier: id, url: image, options: nil)
        
        let content = UNMutableNotificationContent()
        content.title = model.name.capitalized
        content.body = model.note.capitalized
        content.sound = sound
        content.attachments = [attachment]
        if model.type != "" {
            content.subtitle = "Type: \(model.type)"
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { [unowned self] error in
            if error == nil {
                DispatchQueue.main.async { [self] in
                    viewController.alertError(title: "Notification was saved")
                }
            } else {
                viewController.alertError()
            }
        }
    }
    
    func configureView(action: @escaping () -> ()) -> UIContentUnavailableConfiguration {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No exercises"
        config.image = UIImage(systemName: "figure.strengthtraining.traditional")
        config.button = .plain()
        config.button.image = UIImage(systemName: "plus")
        config.button.baseForegroundColor = FFResources.Colors.activeColor
        config.button.title = "Add exercise"
        config.button.imagePlacement = .leading
        config.button.imagePadding = 2
        config.buttonProperties.primaryAction = UIAction(handler: { _ in
            action()
        })
        return config
    }
    
    func addExercise(vc: UIViewController){
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
}
