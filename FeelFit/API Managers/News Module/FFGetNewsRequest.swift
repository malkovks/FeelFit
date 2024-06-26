//
//  FFGetNewsRequest.swift
//  FeelFit
//
//  Created by Константин Малков on 21.09.2023.
//

import UIKit
import Alamofire

enum RequestSortDescription: String {
    case popularity = "By Popular"
    case publishedAt = "By Published Date"
    case relevancy = "By Relevancy"
    
    static var count: Int {
        return RequestSortDescription.relevancy.hashValue + 1
    }
}


class FFGetNewsRequest {
    
    static var shared = FFGetNewsRequest()
    
    private init() {}
    
    //Функция работает ,данные возвращает
    func getRequestResult(numberOfPage: Int = 1,requestType: String,requestSortType: String,locale: String,completion: @escaping (Result<[Articles],Error>) -> ()){
        
        let type = checkSortType(type: requestSortType)
        let result = setupDates()
        
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(requestType)&from\(result.0)&to\(result.1)&pageSize=20&page=\(numberOfPage)&sortBy=\(type)&language=\(locale)&apiKey=726ada313f7a4371a04f04c875036854") else { return }
        
        let cache = URLCache(memoryCapacity: 100*1024*1024, diskCapacity: 100*1024*1024)
        URLCache.shared = cache
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10
        DispatchQueue.global(qos: .background).async { 
            AF.request(request).validate().responseDecodable(of: APIResponse.self) { response in
                if let data = response.value {
                    completion(.success(data.articles))
                } else {
                    guard let error = response.error else { return }
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    private func setupDates() -> (String,String) {
        let currentDate = Date()
        let calendar = Calendar.current
        let lastDay = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        let lastDayString = lastDay.shortConvertString()
        let currentDayString = Date().shortConvertString()
        return (lastDayString,currentDayString)
    }
    
    private func checkSortType(type: String) -> String {
        if type == RequestSortDescription.popularity.rawValue {
            return "popularity"
        } else if type == RequestSortDescription.relevancy.rawValue {
            return "relevancy"
        } else {
            return "publishedAt"
        }
    }
    
    
}

//"https://newsapi.org/v2/everything?q=fitness&from2023-09-28&to2023-09-29&pageSize=20&page=1&sortBy=publishedAt&apiKey=726ada313f7a4371a04f04c875036854"
