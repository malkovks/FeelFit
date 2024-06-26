//
//  FFGetExercisesDataBase.swift
//  FeelFit
//
//  Created by Константин Малков on 07.11.2023.
//

import Foundation
import Alamofire
import RealmSwift

class FFGetExercisesDataBase {
    static let shared = FFGetExercisesDataBase()
    
    private init() {}

    
    private let realm = try! Realm()
    
    func getMuscleDatabase(muscle: String,limit number: String = "20",filter: String = "exerciseMuscle",completionHandler: @escaping (Result<[Exercise],Error>) -> ()){
        checkForDuplicatesInList()
            
        let valueRequest = checkValueName(name: muscle)
        guard let url = prepareURL(value: valueRequest, number: number, filter: filter) else { return }
        let request = setupRequest(url: url)
        
        let exercises = checkDataAvailable(key: valueRequest, filterString: filter)
        if exercises.count > 0 {
            completionHandler(.success(exercises))
        } else {
            DispatchQueue.global(qos: .background).async {
                AF.request(request).validate().responseDecodable(of: [Exercise].self) { response in
                    switch response.result {
                    case .success(let model):
                        completionHandler(.success(model))
                        FFExerciseStoreManager.shared.saveLoadData(model: model)
                    case .failure(let failure):
                        completionHandler(.failure(failure))
                    }
                }.resume()
            }
        }
    }
    
    private func checkForDuplicatesInList(){
        let objects = realm.objects(FFExerciseModelRealm.self)
        var uniqueValues = Set<String>()
        for object in objects {
            if uniqueValues.contains(object.exerciseID) {
                try! realm.write({
                    realm.delete(object)
                })
            } else {
                uniqueValues.insert(object.exerciseID)
            }
        }
    }
    
    func getUpdateImageLinkBy(exerciseID: String){
        guard let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises/exercise/" + exerciseID) else { return }
        let request = setupRequest(url: url)
        AF.request(request).validate().responseDecodable(of: Exercise.self) { response in
            switch response.result {
            case .success(let exercise):
                let link = exercise.imageLink
                FFExerciseStoreManager.shared.updateImageLink(newImageLink: link, exerciseID: exerciseID)
            case .failure(_):
                break
            }
        }.resume()
    }
    
    private func checkValueName(name: String) -> String{
        var value = String()
        if name.contains("_"){
            value = name.replacingOccurrences(of: "_", with: "%20")
            return value
        } else {
            value = name
            return value
        }
    }
    
    private func checkDataAvailable(key: String,filterString: String) -> [Exercise] {
        let formatKey = key.replacingOccurrences(of: "%20", with: " ")
        let value = FFExerciseStoreManager.shared.loadMusclesData(formatKey, filter: filterString)
        return value
    }
    
    private func prepareURL(value: String,number: String,filter type: String) -> URL? {
        if type == "exerciseMuscle" {
            let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises/target/\(value)?limit=\(number)")
            return url
        } else {
            let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises/bodyPart/\(value)?limit=\(number)")
            return url
        }
    }
    
    private func setupRequest(url: URL) -> URLRequest {
        let headers = [
            "X-RapidAPI-Key": "e0e5e1e85dmsh75869aa45796c4cp15cb28jsn509b82f98306",
            "X-RapidAPI-Host": "exercisedb.p.rapidapi.com"
        ]
        let cache = URLCache(memoryCapacity: 100*1024*1024, diskCapacity: 100*1024*1024)
        URLCache.shared = cache
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
}

