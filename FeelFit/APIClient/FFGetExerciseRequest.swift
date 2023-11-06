//
//  FFGetExerciseRequest.swift
//  FeelFit
//
//  Created by Константин Малков on 30.10.2023.
//

import UIKit
import Alamofire

enum FFExerciseSearchType: String{
    case muscle = "muscle"
    case type = "type"
    case name = "name"
    case equipment = "equipment"
    case difficult = "difficult"
}

class FFGetExerciseRequest {
    
    
    static let shared = FFGetExerciseRequest()
    
    func getRequest(searchValue: String,searchType: FFExerciseSearchType = .muscle,completion: @escaping (Result<[Exercises],Error>) -> ()){
        let urlString = "https://api.api-ninjas.com/v1/exercises?\(searchType.rawValue)="
        guard let value = searchValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        let url = URL(string: urlString + value)!
        var request = URLRequest(url: url)
        request.setValue("xs3hoaaW5heLkn3TKH1MHg==rUST8PMzwyx2K9vE", forHTTPHeaderField: "X-Api-Key")
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10
        
        let cache = URLCache(memoryCapacity: 100*1024, diskCapacity: 100*1024)
        URLCache.shared = cache
        
        AF.request(request).validate().responseDecodable(of: [Exercises].self) { response in
            switch response.result {
            case .success(let exercises):
                completion(.success(exercises))
            case .failure(let error):
                completion(.failure(error))
            }
        }.resume()
    }
}
