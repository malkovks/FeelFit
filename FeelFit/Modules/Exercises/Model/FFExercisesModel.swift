//
//  FFExercisesModel.swift
//  FeelFit
//
//  Created by Константин Малков on 31.10.2023.
//

import UIKit

struct Exercises: Codable, Hashable {
    
    let name: String
    let type: String
    let muscle: String
    let equipment: String
    let difficulty: String
    let instructions: String
    
    
    static func == (lhs: Exercises, rhs: Exercises) -> Bool {
        return lhs.name == rhs.name && lhs.muscle == rhs.muscle
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(muscle)
    }
    
    
}
