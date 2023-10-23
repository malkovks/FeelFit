//
//  FFNewsSettingViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 16.10.2023.
//

import UIKit

class FFNewsSettingViewModel: Coordinating {
    var coordinator: Coordinator?
    
    func didSelectRow(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int,rows: [[String]]){
        if pickerView.tag == 0 {
            let value = rows[0][row]
            UserDefaults.standard.setValue(value, forKey: "localeValue")
        }
        if pickerView.tag == 1 {
            let value = rows[1][row]
            UserDefaults.standard.setValue(value, forKey: "typeRequest")
        }
        if pickerView.tag == 2 {
            let value = rows[2][row]
            UserDefaults.standard.setValue(value, forKey: "sortRequest")
        }
    }
}
