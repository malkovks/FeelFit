//
//  FFNewsSettingViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 16.10.2023.
//

import UIKit

class FFNewsSettingViewModel: Coordinating {
    var coordinator: Coordinator?
    
    func setupRowModel() -> [[String]]{
        var model = [[String]]()
        model.append(["ar","de","en","es","fr","it","nl","no","pt","ru","sv","zh"])
        model.append(["Gym","Fitness","Athletic","Running","Crossfit","Health"])
        model.append(["By Popular","By Published Date","By Relevancy"])
        return model
    }
    
    func didSelectRow(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int,rows: [[String]]){
        if pickerView.tag == 0 {
            let value = rows[0][row]
            UserDefaults.standard.setValue(value, forKey: "localeValue")
            print(value)
        }
        if pickerView.tag == 1 {
            let value = rows[1][row]
            UserDefaults.standard.setValue(value, forKey: "typeRequest")
            print(value)
        }
        if pickerView.tag == 2 {
            let value = rows[2][row]
            UserDefaults.standard.setValue(value, forKey: "sortRequest")
            print(value)
        }
    }
    
    func valueSettings() -> [String] {
        var value  = [String]()
        value.append(UserDefaults.standard.string(forKey: "localeValue") ?? "en" )
        value.append(UserDefaults.standard.string(forKey: "typeRequest") ?? "Fitness" )
        value.append(UserDefaults.standard.string(forKey: "sortRequest") ?? "publishedAt" )
        
        return value
    }
}
