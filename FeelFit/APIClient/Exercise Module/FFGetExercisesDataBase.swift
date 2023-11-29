//
//  FFGetExercisesDataBase.swift
//  FeelFit
//
//  Created by Константин Малков on 07.11.2023.
//

import Foundation
import Alamofire
import RealmSwift



enum ExerciseMusclesType: String {
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
    case pectorals = "pectorals"
    case quads = "quads"
    case serratusAnterior = "serratus_anterior"
    case spine = "spine"
    case traps = "traps"
    case triceps = "triceps"
    case upperBack = "upper_back"
}

class FFGetExercisesDataBase {
    static let shared = FFGetExercisesDataBase()
    
//e0e5e1e85dmsh75869aa45796c4cp15cb28jsn509b82f98306
//993d6b8eacmshf5233f92ac39081p16b3f7jsnc30a9fca4475 - закончился лимит
    
    let realm = try! Realm()
    
    func getMuscleDatabase(muscle: String,limit number: String = "10",completionHandler: @escaping (Result<[Exercise],Error>) -> ()){
        let headers = [
            "X-RapidAPI-Key": "e0e5e1e85dmsh75869aa45796c4cp15cb28jsn509b82f98306",
            "X-RapidAPI-Host": "exercisedb.p.rapidapi.com"
        ]
        var valueRequest = String()
        if muscle.contains("_") {
            valueRequest = muscle.replacingOccurrences(of: "_", with: "%20")
        } else {
            valueRequest = muscle
        }
        
        let cache = URLCache(memoryCapacity: 100*1024*1024, diskCapacity: 100*1024*1024)
        URLCache.shared = cache
        guard let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises/target/\(valueRequest)?limit=\(number)") else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        AF.request(request).validate().responseDecodable(of: [Exercise].self) { [weak self] response in
            guard let urlRequest = response.request else { print("url request unavailable") ;return }
            guard let data = response.data else { print("data unavailable"); return}
            guard let responseRequest = response.response else { print("response request"); return}
            switch response.result {
            case .success(let success):
                self?.saveDataToRealm(model: success)
                let cacheResponse = CachedURLResponse(response: responseRequest, data: data)
                URLCache.shared.storeCachedResponse(cacheResponse, for: urlRequest)
                completionHandler(.success(success))
            case .failure(let failure):
                completionHandler(.failure(failure))
            }
        }.resume()
    }
    func saveDataToRealm(model: [Exercise]){
        let exerciseObjects = model.map { data -> FFExerciseModelRealm in
            let exercise = FFExerciseModelRealm()
            exercise.exerciseID = data.exerciseID
            exercise.exerciseBodyPart = data.bodyPart
            exercise.exerciseEquipment = data.equipment
            exercise.exerciseImageLink = data.imageLink
            exercise.exerciseName = data.exerciseName
            exercise.exerciseMuscle = data.muscle
            exercise.exerciseSecondaryMuscles = data.secondaryMuscles.joined(separator: ", ")
            exercise.exerciseInstructions = data.instructions.joined(separator: ". ")
            return exercise
        }
        try! realm.write({
            realm.add(exerciseObjects)
        })
    }
}

