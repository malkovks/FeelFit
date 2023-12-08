//
//  FFDatePickerViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 08.12.2023.
//

import UIKit

class FFDatePickerViewController: UIViewController, SetupViewController {
    
    var handler: ((String) -> ())?
    
    private var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupViewModel()
        setupDatePicker()
        setupConstraints()
    }
    
    private func setupDatePicker(){
        datePicker = UIDatePicker(frame: .zero)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
//        datePicker.backgroundColor = FFResources.Colors.backgroundColor
        datePicker.backgroundColor = .clear
        datePicker.tintColor = FFResources.Colors.activeColor
        datePicker.locale = .current
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
    }
    
    @objc private func didTapDismiss(){
        if datePicker.date != Date() {
            alertControllerActionConfirm(title: "Warning", message: "Do you want add notification on chosen date?", confirmActionTitle: "Add notification", style: .alert) {
                print("Added")
            } secondAction: {
                print("Not Added")
            }
            self.dismiss(animated: true)
        } else {
            self.dismiss(animated: true)
        }
        
    }
    
    //Сделать функцию которая будет брать дату и время, конвертировать в строковый литерал и возвращать через замыкание в предыдущий вью
    func getChosenDate(datePicker: UIDatePicker){
        
    }
    //сделать добавление и включение уведомлений в случае если пользователь захочет их получать
    func setupNotification(date: Date){
        
    }
    
    func setupNavigationController() {
        title = "Select Date"
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Done", imageName: "", action: #selector(didTapDismiss), menu: nil)
        
    }
    
    func setupViewModel() {
        
    }
}

extension FFDatePickerViewController {
    private func setupConstraints(){
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
