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
    
    func valueSettings() -> [String] {
        var value  = [String]()
        value.append(UserDefaults.standard.string(forKey: "localeRequest") ?? "en" )
        value.append(UserDefaults.standard.string(forKey: "typeRequest") ?? "Fitness" )
        value.append(UserDefaults.standard.string(forKey: "sortRequest") ?? "publishedAt" )
        
        return value
    }
    
    //table view delegate methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,sections: [Section]){
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .automatic)
        }
    }
    
    //Picker view methods
    func didSelectRow(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int,rows: [[String]]){
        if pickerView.tag == 0 {
            let value = rows[0][row]
            UserDefaults.standard.setValue(value, forKey: "localeRequest")
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
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int,rows: [[String]]) -> Int {
        if pickerView.tag == 0 {
            return rows[0].count
        } else if pickerView.tag == 1 {
            return rows[1].count
        } else {
            return rows[2].count
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row:Int, forComponent component: Int, reusing view: UIView?, rows: [[String]]) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.contentMode = .scaleAspectFit
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        label.numberOfLines = 1
        if pickerView.tag == 0 {
            label.text =  rows[0][row].uppercased()
        } else if pickerView.tag == 1 {
            label.text =  rows[1][row]
        } else {
            label.text =  rows[2][row]
        }
        return label
    }
    
    
}
