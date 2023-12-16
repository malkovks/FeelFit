//
//  UIViewController+extension.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import Alamofire

extension UIViewController {
    func setupExerciseSecondaryParameters(handler: @escaping ([String])-> ()?){
        let alertController = UIAlertController(title: "Fill the fields", message: nil, preferredStyle: .alert)
        
        //Label Setup
        let weightLabel = UILabel(frame: .zero)
        weightLabel.text = "Weight :"
        weightLabel.font = UIFont.textLabelFont()
        weightLabel.textColor = FFResources.Colors.textColor
        weightLabel.textAlignment = .justified
        
        let setsLabel = UILabel(frame: .zero)
        setsLabel.text = "Sets :"
        setsLabel.font = UIFont.textLabelFont()
        setsLabel.textColor = FFResources.Colors.textColor
        setsLabel.textAlignment = .justified
        
        let repeatLabel = UILabel(frame: .zero)
        repeatLabel.text = "Repeats :"
        repeatLabel.font = UIFont.textLabelFont()
        repeatLabel.textColor = FFResources.Colors.textColor
        repeatLabel.textAlignment = .justified
        
        let labelStackView = UIStackView(arrangedSubviews: [weightLabel,setsLabel,repeatLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 10
        labelStackView.alignment = .fill
        labelStackView.distribution = .fillProportionally

        //TextField Setup
        let weightTextField = UITextField(frame: .zero)
        weightTextField.borderStyle = .roundedRect
        weightTextField.placeholder = "Weight value"
        weightTextField.keyboardType = .numberPad
        weightTextField.font = UIFont.textLabelFont()
        weightTextField.textColor = FFResources.Colors.textColor
        weightTextField.textAlignment = .center
        
        
        let setsTextField = UITextField(frame: .zero)
        setsTextField.borderStyle = .roundedRect
        setsTextField.placeholder = "Sets value"
        setsTextField.keyboardType = .numberPad
        setsTextField.font = UIFont.textLabelFont()
        setsTextField.textColor = FFResources.Colors.textColor
        setsTextField.textAlignment = .center

        let repeatTextField = UITextField(frame: .zero)
        repeatTextField.borderStyle = .roundedRect
        repeatTextField.placeholder = "Sets value"
        repeatTextField.keyboardType = .numberPad
        repeatTextField.font = UIFont.textLabelFont()
        repeatTextField.textColor = FFResources.Colors.textColor
        repeatTextField.textAlignment = .center

        let textFieldStackView = UIStackView(arrangedSubviews: [weightTextField, setsTextField, repeatTextField])
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = 10
        textFieldStackView.distribution = .fillProportionally
        
        //Stack view from two stack views
        let stackView = UIStackView(arrangedSubviews: [labelStackView,textFieldStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.alignment = .fill
        
        alertController.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(120)
        }
        
        alertController.view.snp.makeConstraints { make in
            make.height.equalTo(220)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let text = weightTextField.text,
                    let secondText = setsTextField.text,
                    let thirdText = repeatTextField.text else {
                return
            }
            let value: [String] = [text, secondText, thirdText]
            handler(value)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
}
