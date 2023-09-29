//
//  FFNewsTableViewDelegate.swift
//  FeelFit
//
//  Created by Константин Малков on 26.09.2023.
//

import UIKit

protocol FFNewsTableViewCellDelegate: AnyObject {
    func selectedCell(indexPath: IndexPath)
}

class FFNewsTableViewDelegate: NSObject, UITableViewDelegate{
    
    weak var delegate: FFNewsTableViewCellDelegate?
    private var model = [Articles]()
    
    init(with delegate: FFNewsTableViewCellDelegate? = nil,model: [Articles] = [Articles]()) {
        self.delegate = delegate
        self.model = model
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = model[indexPath.row]
        dump(model)
        delegate?.selectedCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height/4
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == model.count - 1 {
//            let pageNumber = model.count/20
//            let viewModel = FFNewsPageViewModel()
//            viewModel.uploadNewData(pageNumber: pageNumber)
//        }
    }
}
