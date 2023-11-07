//
//  FFGetExercisesDataBase.swift
//  FeelFit
//
//  Created by Константин Малков on 07.11.2023.
//

import Foundation
import Alamofire



enum ExerciseMuscles: String {
    case abductors = "abductors"
    case abs = "abs"
    case adductors = "adductors"
    case biceps = "biceps"
    case calves = "calves"
    case cardiovascularSystem = "cardiovascular_system"
    case delts = "delts"
    case forearms = "forearms"
    case glutes = "glutes"
    case hamstrings = "hamstrings"
    case lats = "lats"
    case levatorScapulae = "levator_scapulae"
    case pectorals = "pectorals"
    case quads = "quads"
    case serratusAnterior = "serratus_anterior"
    case spine = "spine"
    case traps = "traps"
    case triceps = "triceps"
    case upperBack = "upper_back"
}

class SetupExerciseLoadingRequest {
    static let shared = SetupExerciseLoadingRequest()
    
    func getData(muscle: ExerciseMuscles,completionHandler: @escaping (Result<[Exercise],Error>) -> ()){
        let headers = [
            "X-RapidAPI-Key": "993d6b8eacmshf5233f92ac39081p16b3f7jsnc30a9fca4475",
            "X-RapidAPI-Host": "exercisedb.p.rapidapi.com"
        ]
        var valueRequest = String()
        if muscle.rawValue.contains("_") {
            valueRequest = muscle.rawValue.replacingOccurrences(of: "_", with: "%20")
        } else {
            valueRequest = muscle.rawValue
        }
        print(valueRequest)
        guard let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises/target/\(valueRequest)?limit=10") else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        AF.request(request).validate().responseDecodable(of: [Exercise].self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(.success(success))
            case .failure(let failure):
                completionHandler(.failure(failure))
            }
        }.resume()
        
        
    }
}

