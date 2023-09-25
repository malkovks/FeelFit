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
    func requestData()
}
///View model for FFNewsPageViewController
final class FFNewsPageViewModel: FFNewsViewModelType {
    weak var delegate: FFNewsPageDelegate?
    private var localModel = Array<Articles>()
    
    ///function for request data from API
    func requestData() {
        delegate?.willLoadData()
        let request = FFGetNewsRequest.shared
        request.getRequestResult { [weak self] result in
            switch result{
            case .success(let data):
                self?.delegate?.didLoadData(model: data, error: nil)
            case .failure(let error):
                self?.delegate?.didLoadData(model: nil, error: error)
            }
        }
    }
    
    
}
