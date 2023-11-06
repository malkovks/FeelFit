//
//  FFGetPlanExerciseRequest.swift
//  FeelFit
//
//  Created by Константин Малков on 06.11.2023.
//

import UIKit
import Alamofire

class FFGetPlanExerciseRequest {
    
    static let shared = FFGetPlanExerciseRequest()
    
    func getRequest(time: Int = 30,equipment: String = "none",muscle: String = "",fitnessLevel: String = "beginner",fitnessGoals: String = "strength",completion: @escaping (Result<WorkoutModel,Error>) -> ()){
        let headers = ["X-RapidAPI-Key": "993d6b8eacmshf5233f92ac39081p16b3f7jsnc30a9fca4475",
                       "X-RapidAPI-Host": "workout-planner1.p.rapidapi.com"]
        
        let equipmentValue = equipment.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let muscleValue = muscle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://workout-planner1.p.rapidapi.com/?time=\(time)&muscle=\(muscleValue)&location=gym&equipment=\(equipmentValue)"
        guard let urlValue = URL(string: url) else { return }
        var request = URLRequest(url: urlValue, cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
        request.allHTTPHeaderFields = headers
        
        let cache = URLCache(memoryCapacity: 100*1024, diskCapacity: 100*1024)
        URLCache.shared = cache
        

        AF.request(request).validate().responseDecodable(of: WorkoutModel.self) { response in
            switch response.result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }.resume()
        
    }
    
    func getData(){
        let headers = [
            "X-RapidAPI-Key": "993d6b8eacmshf5233f92ac39081p16b3f7jsnc30a9fca4475",
            "X-RapidAPI-Host": "workout-planner1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://workout-planner1.p.rapidapi.com/?time=30&muscle=biceps&location=gym&equipment=dumbbells")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                print(response)
                let httpResponse = response as? HTTPURLResponse
                
            }
        })

        dataTask.resume()
    }
}
