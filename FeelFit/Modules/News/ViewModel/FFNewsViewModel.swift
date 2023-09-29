//
//  ViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 19.09.2023.
//

import UIKit

///ViewModel delegate protocol
protocol FFNewsPageDelegate: AnyObject {
    func willLoadData()
    func didLoadData(model: [Articles]?,error: Error?)
    func didUpdateData(model: [Articles]?,error: Error?)
}

///VIewModel setup protocol
protocol FFNewsViewModelType {
    var delegate: FFNewsPageDelegate? { get set }
    func requestData(pageNumber: Int,type: RequestLoadingType)
//    func uploadNewData(pageNumber: Int)
}
///View model for FFNewsPageViewController
final class FFNewsPageViewModel: FFNewsViewModelType {
    
    weak var delegate: FFNewsPageDelegate?
    private var localModel = Array<Articles>()
    var typeRequest: RequestLoadingType = .fitness
    
    var refreshControll: UIRefreshControl = {
       let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Grab to refresh")
        refresh.tintColor = FFResources.Colors.activeColor
        return refresh
    }()
    
    ///function for request data from API
    func requestData(pageNumber: Int = 1,type: RequestLoadingType = .fitness) {
        typeRequest = type
        print(typeRequest)
        delegate?.willLoadData()
        let request = FFGetNewsRequest.shared
        request.getRequestResult(numberOfPage: pageNumber,requestType: type) { [weak self] result in
            switch result{
            case .success(let data):
                self?.delegate?.didLoadData(model: data, error: nil)
            case .failure(let error):
                self?.delegate?.didLoadData(model: nil, error: error)
            }
        }
    }
    
//    func uploadNewData(pageNumber: Int = 1){
//        let type = typeRequest
//        delegate?.willLoadData()
//        let request = FFGetNewsRequest.shared
//        request.getRequestResult(numberOfPage: pageNumber,requestType: type) { [weak self] result in
//            switch result {
//            case .success(let data):
//                self?.delegate?.didUpdateData(model: data, error: nil)
//            case .failure(let error):
//                self?.delegate?.didUpdateData(model: nil, error: error)
//            }
//        }
//    }
    
    
}
