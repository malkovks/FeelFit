//
//  FFMuscleGroupSelectionViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 01.12.2023.
//

import UIKit

class FFMuscleGroupSelectionViewModel {
    
    let viewController: UIViewController
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func settingSegmentController(segment: UISegmentedControl, firstData: [String:String],secondData: [String:String]) -> [String: String] {
        if segment.selectedSegmentIndex == 0{
            return firstData
        } else {
            return secondData
        }
    }
    
    func indexReturnResult(indexPath: IndexPath,firstData: [String: String],secondData: [String: String],segment: UISegmentedControl) -> (String,String) {
        if segment.selectedSegmentIndex == 0 {
            let key: String = Array(firstData.keys.sorted())[indexPath.row]
            return (key, "exerciseMuscle")
        } else {
            let key: String = Array(secondData.keys.sorted())[indexPath.row]
            return (key, "exerciseBodyPart")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,key: String, request: String,controller: UIViewController) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewController.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
}
