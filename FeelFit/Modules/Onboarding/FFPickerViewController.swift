//
//  FFPickerViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 13.03.2024.
//

import UIKit

class FFPickerViewController: UIViewController {
    
    var pickerData = ["One","Two","Three","Four","Five"]
    
    let pickerView : UIPickerView = UIPickerView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
}

extension FFPickerViewController: SetupViewController {
    func setupView() {
        setupNavigationController()
        setupViewModel()
        view.backgroundColor = .clear
        setupBlurEffectBackgroundView(.systemChromeMaterial, .fill)
    }
    
    private func setupPickerView(){
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        
    }
}

extension FFPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
}

extension FFPickerViewController: UIPickerViewDelegate {
    
}

extension FFPickerViewController {
    private func setupConstraints(){
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
}


