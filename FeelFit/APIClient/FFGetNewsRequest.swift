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
    
    //request содержит ссылку поиска по всем странам заданного вопроса. Размер страницы стоит пока 5, можно ставить до 100, но много так не нужно
    private var request = "https://newsapi.org/v2/everything?q=fitness&pageSize=20&page=1&apiKey=726ada313f7a4371a04f04c875036854"
    
    //Функция работает ,данные возвращает
    func getRequestResult(numberOfPage: Int = 1,requestType: RequestLoadingType = .fitness,completion: @escaping (Result<[Articles],Error>) -> ()){
        let currentDate = Date()
        let calendar = Calendar.current
        let lastDay = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let lastDayString = dateFormatter.string(from: lastDay)
        let currentDayString = dateFormatter.string(from: currentDate)
        
        let requestType = requestType.rawValue
        
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(requestType)&from\(lastDayString)&to\(currentDayString)&pageSize=20&page=\(numberOfPage)&apiKey=726ada313f7a4371a04f04c875036854") else { return }
        AF.request(url).responseJSON { response in
            if let data = response.data {
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(APIResponse.self, from: data)
                    completion(.success(model.articles))
                } catch {
                    completion(.failure(error))
                    print("Error parsing data")
                }
            }else {
                guard let error = response.error else { return }
                completion(.failure(error))
            }
        }
    }
}
