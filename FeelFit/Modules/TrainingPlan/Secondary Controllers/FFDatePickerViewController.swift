//
//  FFDatePickerViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 08.12.2023.
//

import UIKit

class FFDatePickerViewController: UIViewController, SetupViewController {
    
    var handler: ((Date,Bool) -> ())?
    
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
        datePicker.backgroundColor = .clear
        datePicker.tintColor = FFResources.Colors.activeColor
        datePicker.locale = .current
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.backgroundColor
    }
    
    @objc private func didTapDismiss(){
        let date = datePicker.date
        if datePicker.date != Date() {
            alertControllerActionConfirm(title: "Warning", message: "Do you want add notification on chosen date?", confirmActionTitle: "Add notification", style: .alert) { [unowned self] in
                handler?(date,true)
                dismiss(animated: true)
            } secondAction: { [unowned self] in
                handler?(date,false)
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
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
