//
//  FFGetExerciseRequest.swift
//  FeelFit
//
//  Created by Константин Малков on 30.10.2023.
//

import UIKit
import Alamofire

class FFGetExerciseRequest {
    func getRequest(){
        var urlString = "https://api.api-ninjas.com/v1/exercises?muscle="
        let muscle = "biceps".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString + muscle!)!
        var request = URLRequest(url: url)
        request.setValue("xs3hoaaW5heLkn3TKH1MHg==rUST8PMzwyx2K9vE", forHTTPHeaderField: "X-Api-Key")
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10
        
        let cache = URLCache(memoryCapacity: 100*1024, diskCapacity: 100*1024)
        URLCache.shared = cache
        
        AF.request(request)
            .validate()
//            .responseDecodable(of: <#T##Decodable.Protocol#>, completionHandler: <#T##(DataResponse<Decodable, AFError>) -> Void#>)
        
    }
}
