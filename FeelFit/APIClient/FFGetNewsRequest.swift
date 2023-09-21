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
    
    private var request = "https://newsapi.org/v2/everything?q=tesla&from=2023-08-24&sortBy=publishedAt&apiKey=9679b37384304d6d80fabceb7d7a5c59"
    
        
    func getRequestResult(completion: @escaping (Result<[Articles],Error>) -> ()){
        guard let url = URL(string: request) else { return }
        AF.request(url).responseJSON { response in
            
            if let data = response.data {
//                print(String(data: data, encoding: .utf8) as Any)
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(APIResponse.self, from: data)
                    
                    completion(.success(model.articles))
                } catch {
//                    completion(.failure(error))
                    print("Error parsing data")
                }
            }else {
                guard let error = response.error else { return }
                completion(.failure(error))
            }
        }
    }
//    func getRequest(completion: @escaping (Result<[Articles],Error>) -> ()){
//        guard let url = URL(string: request) else { return }
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription as Any)
//                return
//            }
//            do {
//                let result = try JSONDecoder().decode(Root.self, from: data)
//                DispatchQueue.main.async {
//                    print(result.articles.count)
//                    completion(.success(result.articles))
//                }
//            }
//            catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
}
