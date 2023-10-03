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
}

///VIewModel setup protocol
protocol FFNewsViewModelType {
    var delegate: FFNewsPageDelegate? { get set }
    func requestData(pageNumber: Int,type: Request.RequestLoadingType,filter: Request.RequestSortType)
//    func uploadNewData(pageNumber: Int)
}
///View model for FFNewsPageViewController
final class FFNewsPageViewModel: FFNewsViewModelType {
    
    weak var delegate: FFNewsPageDelegate?
    private var localModel = Array<Articles>()
    var typeRequest: Request.RequestLoadingType = .fitness
    var sortRequest: Request.RequestSortType = .publishedAt
    var localeRequest: String = String(Locale.preferredLanguages.first!.prefix(2))
    
    var refreshControll: UIRefreshControl = {
       let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Grab to refresh")
        refresh.tintColor = FFResources.Colors.activeColor
        return refresh
    }()
    
    ///function for request data from API
    func requestData(pageNumber: Int = 1,type: Request.RequestLoadingType = .fitness,filter: Request.RequestSortType = .publishedAt) {
        typeRequest = type
        
        
        delegate?.willLoadData()
        let request = FFGetNewsRequest.shared
        request.getRequestResult(numberOfPage: pageNumber,requestType: type,requestSortType: filter,locale: localeRequest) { [weak self] result in
            switch result{
            case .success(let data):
                self?.delegate?.didLoadData(model: data, error: nil)
            case .failure(let error):
                self?.delegate?.didLoadData(model: nil, error: error)
            }
        }
    }
}
