//
//  FFNewsTableViewDelegate.swift
//  FeelFit
//
//  Created by Константин Малков on 26.09.2023.
//

import UIKit

class FFNewsTableViewDelegate: NSObject, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selection work fine")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height/4
    }
}
