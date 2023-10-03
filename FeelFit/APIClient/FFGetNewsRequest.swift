//
//  FFGetNewsRequest.swift
//  FeelFit
//
//  Created by Константин Малков on 21.09.2023.
//

import UIKit
import Alamofire




class FFGetNewsRequest {
    
    static var shared = FFGetNewsRequest()
    
    //Функция работает ,данные возвращает
    func getRequestResult(numberOfPage: Int = 1,requestType: Request.RequestLoadingType = .fitness,requestSortType: Request.RequestSortType = .publishedAt,locale: String = String(Locale.preferredLanguages.first!.prefix(2)),completion: @escaping (Result<[Articles],Error>) -> ()){
        
        let result = setupDates()
        let requestType = requestType.rawValue
        
        
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(requestType)&from\(result.0)&to\(result.1)&pageSize=20&page=\(numberOfPage)&sortBy=\(requestSortType)&language=\(locale)&apiKey=726ada313f7a4371a04f04c875036854") else { return }
        
        let cache = URLCache(memoryCapacity: 100*1024*1024, diskCapacity: 100*1024*1024)
        URLCache.shared = cache
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.timeoutInterval = 10

        AF.request(request).responseJSON { response in
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(APIResponse.self, from: data)
                    completion(.success(model.articles))
                } catch {
                    completion(.failure(error))
                }
            }else {
                guard let error = response.error else { return }
                completion(.failure(error))
            }
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
}

//"https://newsapi.org/v2/everything?q=fitness&from2023-09-28&to2023-09-29&pageSize=20&page=1&sortBy=publishedAt&apiKey=726ada313f7a4371a04f04c875036854"
